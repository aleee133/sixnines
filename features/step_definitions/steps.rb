# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2017-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'tmpdir'
require 'English'

Before do
  @cwd = Dir.pwd
  @dir = Dir.mktmpdir('test')
  FileUtils.mkdir_p(@dir)
  Dir.chdir(@dir)
end

After do
  Dir.chdir(@cwd)
  FileUtils.rm_rf(@dir)
end
