#
#Sunny软件公司欲基于Java语言开发一套图表库，
#该图表库可以为应用系统提供各种不同外观的图表，例如柱状图、饼状图、折线图等。
#Sunny软件公司图表库设计人员希望为应用系统开发人员提供一套灵活易用的图表库，
#而且可以较为方便地对图表库进行扩展，以便能够在将来增加一些新类型的图表。
#
#
require 'active_support/all'

class ChartFactory
  def self.get_chart(type)
    const_get("#{type.classify}Chart").new
  rescue NameError=> e
    raise '无效的参数'
    p e
  end
end

class Chart
  def show
    p '显示图表'
  end
end

class LineChart < Chart

  def initialize
    p '创建线状图'
  end

  def show
    p '显示线状图'
  end

end

class PieChart < Chart

  def initialize
    p '创建饼状图'
  end

  def show
    p '显示饼状图'
  end

end


pie = ChartFactory.get_chart('pie')
pie.show
line = ChartFactory.get_chart('line')
line.show


