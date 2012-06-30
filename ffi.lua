local ffi = require "ffi"
local fs = require "fs"

-- Feed the header to ffi
ffi.cdef(fs.readFileSync("uvffi.h"))
-- Cache the C namespace object
local C = ffi.C
-- Create our lua module
local uv = {}

local function uvCheck(err)
  if err.code == 0 then return end
  local name = ffi.string(C.uv_err_name(err))
  local message = ffi.string(C.uv_strerror(err))
  error(name .. ": " .. message)
end

function uv.getProcessTitle()
  local buffer = ffi.new("char[MAX_TITLE_LENGTH]")
  uvCheck(C.uv_get_process_title(buffer, C.MAX_TITLE_LENGTH))
  return ffi.string(buffer)
end

function uv.setProcessTitle(title)
  uvCheck(C.uv_set_process_title(title))
end

p(uv.getProcessTitle())
uv.setProcessTitle("FOOMONKEY")
p(uv.getProcessTitle())

