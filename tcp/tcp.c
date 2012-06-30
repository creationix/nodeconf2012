#include <stdio.h>
#include <stdlib.h>
#include "uv.h"

/* Helper for exiting on errors */
static void error(const char* name) {
  uv_err_t err = uv_last_error(uv_default_loop());
  fprintf(stderr, "%s: %s\n", name, uv_strerror(err));
  exit(-1);  
}

/* Hook to allocate data for read events */
static uv_buf_t on_alloc(uv_handle_t* handle, size_t suggested_size) {
  return uv_buf_init(malloc(suggested_size), suggested_size);
}

static void on_close(uv_handle_t* handle) {
  free(handle);
	printf("disconnected\n");
}

/* Callback on data chunk from client */
static void on_read(uv_stream_t* stream, ssize_t nread, uv_buf_t buf) {
  if (nread >= 0) {
    printf("chunk: %.*s", (int)nread, buf.base);
  } else {
    uv_err_t err = uv_last_error(uv_default_loop());
    if (err.code == UV_EOF) {
      printf("eof\n");
      uv_close((uv_handle_t*)stream, on_close);
    } else {
      fprintf(stderr, "read: %s\n", uv_strerror(err));
      exit(-1);
    }
  }
  free(buf.base);
}

/* Callback for new tcp client connections */
static void on_connection(uv_stream_t* server, int status) {
	uv_tcp_t* client;
	
	if (status) error("on_connection");

  client = malloc(sizeof(uv_tcp_t));
  uv_tcp_init(uv_default_loop(), client);

  /* Accept the client */
  if (uv_accept((uv_stream_t*)server, (uv_stream_t*)client)) {
    error("accept");
  }

	printf("connected\n");
  
  /* Start reading data from the client */
  uv_read_start((uv_stream_t*)client, on_alloc, on_read);
}

int main() {
  
  /* Initialize the tcp server handle */
  uv_tcp_t* server = malloc(sizeof(uv_tcp_t));
  uv_tcp_init(uv_default_loop(), server);

  /* Bind to port 8080 on "0.0.0.0" */
	printf("Binding to port 8080\n");
  if (uv_tcp_bind(server, uv_ip4_addr("0.0.0.0", 8080))) {
    error("bind");
  }
  
  /* Listen for connections */
	printf("Listening for connections\n");
  if (uv_listen((uv_stream_t*)server, 128, on_connection)) {
    error("listen");
  }

  /* Block in the main loop */
  uv_run(uv_default_loop());
  return 0;
}
