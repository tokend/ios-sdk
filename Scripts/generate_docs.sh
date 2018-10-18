
module=$(ruby ./Scripts/get_podspec_value.rb "name")
version=$(ruby ./Scripts/get_podspec_value.rb "version")
swift_version=$(ruby ./Scripts/get_podspec_value.rb "swift_version")

jazzy_parameters_string="--module=${module} --module-version=${version} --swift-version=${swift_version}"

echo "jazzy params: '${jazzy_parameters_string}'"

jazzy $jazzy_parameters_string\
&& cd Example
pod install
cd ..
