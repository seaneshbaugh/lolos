require 'fileutils'
require 'yaml'

Dir.chdir(__dir__)

dependencies = YAML.load_file('dependencies.yml')

binutils_version = dependencies['binutils']['version']

gcc_version = dependencies['gcc']['version']

gmp_version = dependencies['gmp']['version']

mpfr_verrsion = dependencies['mpfr']['version']

isl_version = dependencies['isl']['version']

cloog_version = dependencies['cloog']['version']

mpc_version = dependencies['mpc']['version']

libiconv_version = dependencies['libiconv']['version']

texinfo_version = dependencies['texinfo']['version']

prefix = "#{ENV['HOME']}/opt/cross"

target = 'i686-elf'

path = "#{prefix}/bin:#{ENV['PATH']}"

env = { 'PREFIX' => prefix, 'TARGET' => target, 'PATH' => path }

src_directory = 'compiler-src'

build_directory = 'compiler-build'

FileUtils.mkdir_p(build_directory)

FileUtils.cp_r(File.join(src_directory, "isl-#{isl_version}"), File.join(src_directory, "binutils-#{binutils_version}", 'isl'))

FileUtils.cp_r(File.join(src_directory, "cloog-#{cloog_version}"), File.join(src_directory, "binutils-#{binutils_version}", 'cloog'))

binutils_build_directory = File.join(build_directory, 'binutils')

FileUtils.rm_rf(binutils_build_directory)

FileUtils.mkdir_p(binutils_build_directory)

puts 'Compiling and installing binutils.'

Dir.chdir(binutils_build_directory) do
  unless system(env, "../../#{src_directory}/binutils-#{binutils_version}/configure --target=#{target} --prefix=\"$PREFIX\" --disable-nls --disable-werror --enable-interwork --enable-multilib")
    raise 'Error configuring binutils.'
  end

  unless system(env, 'make')
    raise 'Error making binutils.'
  end

  unless system(env, 'make install')
    raise 'Error installing binutils.'
  end

  unless system(env, "which -- #{target}-as")
    raise "Could not find #{target}-as executable. Make sure binutils was successfully built and installed."
  end
end

puts 'Done compiling and installing binutils.'

FileUtils.cp_r(File.join(src_directory, "libiconv-#{libiconv_version}"), File.join(src_directory, "gcc-#{gcc_version}", 'libiconv'))

FileUtils.cp_r(File.join(src_directory, "gmp-#{gmp_version}"), File.join(src_directory, "gcc-#{gcc_version}", 'gmp'))

FileUtils.cp_r(File.join(src_directory, "mpfr-#{mpfr_version}"), File.join(src_directory, "gcc-#{gcc_version}", 'mpfr'))

FileUtils.cp_r(File.join(src_directory, "mpc-#{mpc_version}"), File.join(src_directory, "gcc-#{gcc_version}", 'mpc'))

FileUtils.cp_r(File.join(src_directory, "isl-#{isl_version}"), File.join(src_directory, "gcc-#{gcc_version}", 'isl'))

FileUtils.cp_r(File.join(src_directory, "cloog-#{cloog_version}"), File.join(src_directory, "gcc-#{gcc_version}", 'cloog'))

gcc_build_directory = File.join(build_directory, 'gcc')

FileUtils.rm_rf(gcc_build_directory)

FileUtils.mkdir_p(gcc_build_directory)

puts 'Compiling and installing gcc.'

Dir.chdir(gcc_build_directory) do
  unless system(env, "../../#{src_directory}/gcc-#{gcc_version}/configure --target=#{target} --prefix=\"#{prefix}\" --disable-nls --enable-languages=c,c++ --without-headers")
    raise 'Error configuring gcc.'
  end

  unless system(env, 'make all-gcc')
    raise 'Error making all-gcc.'
  end

  unless system(env, 'make all-target-libgcc')
    raise 'Error making all-target-libgcc.'
  end

  unless system(env, 'make install-gcc')
    raise 'Error installing all-gcc.'
  end

  unless system(env, 'make install-target-libgcc')
    raise 'Error installing target-libgcc.'
  end

  unless system(env, "which -- #{target}-gcc")
    raise "Could not find #{target}-gcc executable. Make sure gcc was successfully built and installed."
  end
end

puts 'Done compiling and installing gcc.'
