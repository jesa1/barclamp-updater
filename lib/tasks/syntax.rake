#
# Copyright 2011-2013, Dell
# Copyright 2013-2015, SUSE Linux GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

namespace :syntaxcheck do
  require "erb"
  require "open3"
  require "yaml"

  task :yaml do
    failed = false

    Dir["**/*.yml"].each do |file|
      next if skip_path? file

      begin
        YAML.load_file file
        success_check file, "OK"
      rescue => e
        match = e.message.match(/at line (\d+) column (\d+)/)

        if match
          failed_check file, "line #{match[1]}, column #{match[2]}"
        else
          failed_check file, e.message.split(":", 2).last.strip
        end

        failed = true
      end
    end

    abort "Validation for Yaml failed" if failed
  end

  task :ruby do
    failed = false
    current_bin = "ruby"

    Dir["**/*.rb"].each do |file|
      next if skip_path? file

      Open3.popen3("#{current_bin} -Ku -c #{file}") do |stdin, stdout, stderr|
        error = begin
          stderr.readline
        rescue
          false
        end

        if error
          failed_check file, error
          failed = true
        else
          success_check file, "OK"
        end

        stdin.close || false
        stdout.close || false
        stderr.close || false
      end
    end

    abort "Validation for Ruby failed" if failed
  end

  task :erb do
    failed = false
    current_bin = "ruby"

    Dir["**/*.erb"].each do |file|
      next if skip_path? file

      Open3.popen3("#{current_bin} -Ku -c") do |stdin, stdout, stderr|
        stdin.puts(
          ERB.new(
            File.read(file),
            nil,
            "-"
          ).src
        )

        stdin.close

        error = begin
          stderr.readline
        rescue
          false
        end

        if error
          failed_check file, error[1..-1].sub(/^[^:]*:\d+: /, "")
          failed = true
        else
          success_check file, "OK"
        end

        stdout.close || false
        stderr.close || false
      end
    end

    abort "Validation for Erb failed" if failed
  end

  task :haml do
    begin
      failed = false
      current_bin = bin_path("haml")

      Dir["**/*.haml"].each do |file|
        next if skip_path? file

        Open3.popen3("#{current_bin} -c #{file}") do |stdin, stdout, stderr|
          error = begin
            stderr.readline
          rescue
            false
          end

          if error
            failed_check file, error
            failed = true
          else
            success_check file, "OK"
          end

          stdin.close || false
          stdout.close || false
          stderr.close || false
        end
      end

      abort "Validation for Haml failed" if failed
    rescue Gem::LoadError
      failed_check "haml", "failed find or load haml"
    end
  end

  task :sass do
    begin
      failed = false
      current_bin = bin_path("sass")

      Dir["**/*.sass"].each do |file|
        next if skip_path? file

        Open3.popen3("#{current_bin} -c #{file}") do |stdin, stdout, stderr|
          error = begin
            stderr.readline
          rescue
            false
          end

          if error
            failed_check file, error
            failed = true
          else
            success_check file, "OK"
          end

          stdin.close || false
          stdout.close || false
          stderr.close || false
        end
      end

      abort "Validation for Sass failed" if failed
    rescue Gem::LoadError
      failed_check "sass", "failed find or load sass"
    end
  end

  def failed_check(file, message = nil)
    STDERR.puts [
      "#{file}:",
      "\e[31m#{message}\e[0m"
    ].compact.join(" ")
  end

  def success_check(file, message = nil)
    STDOUT.puts [
      "#{file}:",
      "\e[32m#{message}\e[0m"
    ].compact.join(" ")
  end

  def bin_path(gem_name, bin_name = nil)
    spec = Gem::Specification.find_by_name(gem_name)

    File.join(
      spec.gem_dir,
      spec.bindir,
      bin_name || gem_name
    ) if spec
  end

  def skip_path?(file)
    %w(
      tmp
      spec/vendor
      vendor/gems
      vendor/rails
    ).each do |name|
      return true if file.match name
    end

    false
  end
end

desc "Check syntax of various file types"
task :syntaxcheck do
  Rake::Task["syntaxcheck:ruby"].invoke
  Rake::Task["syntaxcheck:erb"].invoke
  Rake::Task["syntaxcheck:yaml"].invoke
  Rake::Task["syntaxcheck:haml"].invoke
  Rake::Task["syntaxcheck:sass"].invoke
end
