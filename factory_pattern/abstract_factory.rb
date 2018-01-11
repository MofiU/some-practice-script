# Sunny软件公司欲开发一套界面皮肤库，可以对Java桌面软件进行界面美化。
# 为了保护版权，该皮肤库源代码不打算公开，而只向用户提供已打包为jar文件的class字节码文件。
# 用户在使用时可以通过菜单来选择皮肤，
# 不同的皮肤将提供视觉效果不同的按钮、文本框、组合框等界面元素，其结构示意图如图1所示：


#                        -- green button
#        -- spring style -- green field
#                        -- green combobox
# skin --
#                        -- gray button
#        -- summer style -- gray field
#                        -- gray comboxbox
#



require 'active_support/all'

class SkinFactory
  attr_reader :type
  def initialize(type)
    @type = type
  end

  def create_button
    Kernel.const_get("#{type.classify}Button").new
  end

  def create_textfield
    Kernel.const_get("#{type.classify}TextField").new
  end

  def create_combobox
    Kernel.const_get("#{type.classify}Combobox").new
  end
end


class Button

end

class SpringButton < Button
  def show
    p 'Green Button'
  end
end

class SummerButton < Button
  def show
    p 'Gray Button'
  end
end

class TextField

end

class SpringTextField < TextField
  def show
    p 'Green TextField'
  end
end

class SummerTextField < TextField
  def show
    p 'Gray TextField'
  end
end

class Combobox

end

class SpringCombobox < Combobox
  def show
    p 'Green Combobox'
  end
end

class SummerCombobox < Combobox
  def show
    p 'Gray Combobox'
  end
end



skin = SkinFactory.new('spring')
bt = skin.create_button
bt.show

tf = skin.create_textfield
tf.show

cb = skin.create_combobox
cb.show

skin = SkinFactory.new('summer')
bt = skin.create_button
bt.show

tf = skin.create_textfield
tf.show

cb = skin.create_combobox
cb.show