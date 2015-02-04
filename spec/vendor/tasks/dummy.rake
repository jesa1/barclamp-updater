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

namespace :barclamp do
  namespace :updater do
    desc "Generates a dummy app for testing"
    task dummy_app: [:setup_dummy_app, :migrate_dummy_app]

    task :setup_dummy_app do
      require "rails"
      require "barclamp-updater"

      require File.expand_path(
        "../../generators/barclamp/updater/dummy/dummy_generator", __FILE__)

      Barclamp::Updater::DummyGenerator.start %w(--quiet)
    end

    task :migrate_dummy_app do
      ENV["RAILS_ENV"] = "test"
      root = Barclamp::Updater::Engine.root.join("spec", "dummy")

      if root.exist?
        Dir.chdir root do
          system(
            "bundle exec rake",
            "barclamp:updater:install:migrations",
            "db:drop",
            "db:create",
            "db:migrate",
            "db:seed"
          )
        end
      end
    end

    desc "Remove the dummy app for testing"
    task :dummy_remove do
      Barclamp::Updater::Engine.root.join("spec", "dummy").rmtree
    end
  end
end
