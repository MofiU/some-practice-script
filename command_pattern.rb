require 'active_support/all'

class Invoker

  attr_accessor :command

  attr_accessor :composite_command

  def call
    command.execute
  end

  def queen_call
    composite_command.execute
  end

end

class Command

  attr_reader :receiver, :description

  def initialize(description)
    @receiver = Kernel.const_get("#{description.classify}").new
  end

  def execute
    receiver.action
  end

end

class Receiver
  def action
    raise
  end
end

class IceBall < Receiver
  def action
    p '冰球'
    p '增加回血速度,技能持续时间'
  end
end

class ThunderBall < Receiver
  def action
    p '雷球'
    p '增加移动速度,技能持续距离'
  end
end

class FireBall < Receiver
  def action
    p '火球'
    p '增加攻击力,技能伤害'
  end
end

class CompositeCommand

  attr_reader :command_queen

  def initialize
    @command_queen = []
  end

  def add_command(command)
    @command_queen << command
  end

  def execute
    @command_queen.each do |command|
      command.execute
    end
    @command_queen.clear
  end

end

ice_ball = Command.new('ice_ball')
thunder_ball = Command.new('thunder_ball')
fire_ball = Command.new('fire_ball')

invoker = Invoker.new

invoker.command = ice_ball

invoker.call

invoker.command = thunder_ball

invoker.call

invoker.command = fire_ball

invoker.call


p '------------------------------------'

composite_command = CompositeCommand.new

composite_command.add_command(ice_ball)
composite_command.add_command(thunder_ball)
composite_command.add_command(fire_ball)

invoker.composite_command = composite_command

invoker.queen_call