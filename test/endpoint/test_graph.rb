# frozen_string_literal: true

# Copyright (c) 2017-2022 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'test/unit'
require 'rack/test'
require_relative '../../objects/endpoint/ep_graph'

class GraphTest < Test::Unit::TestCase
  def test_renders_svg
    endpoint = Class.new do
      def history
        [
          { time: Time.now - 16_000, msec: 120, code: 200 },
          { time: Time.now - 12_000, msec: 4000, code: 200 },
          { time: Time.now - 4800, msec: 210, code: 200 },
          { time: Time.now - 2400, msec: 110, code: 200 },
          { time: Time.now - 1800, msec: 210, code: 503 },
          { time: Time.now - 320, msec: 107, code: 200 },
          { time: Time.now - 220, msec: 210, code: 200 },
          { time: Time.now - 60, msec: 450, code: 503 },
          { time: Time.now, msec: 75, code: 200 }
        ]
      end
    end.new
    target = File.join(Dir.pwd, 'target')
    FileUtils.mkdir_p(target)
    svg = EpGraph.new(endpoint).to_svg
    File.write(File.join(target, 'graph.svg'), svg)
    assert(svg.include?('<svg'))
  end

  def test_calculates_avg
    endpoint = Class.new do
      def history
        [
          { time: Time.now - 180, msec: 1298, code: 200 },
          { time: Time.now - 120, msec: 217, code: 200 },
          { time: Time.now - 60, msec: 451, code: 503 },
          { time: Time.now, msec: 75, code: 200 }
        ]
      end
    end.new
    assert_equal(510, EpGraph.new(endpoint).avg)
  end
end
