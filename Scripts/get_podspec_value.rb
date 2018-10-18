require 'json'

key = ARGV[0]

podspec_json_string = %x(pod ipc spec TokenDSDK.podspec)
podspec_json = JSON.parse(podspec_json_string)

value = podspec_json[key]

puts(value)
