# Sunny软件公司游戏开发小组决定开发一款名为《Sunny群侠传》的网络游戏，
# 该游戏采用主流的RPG(Role Playing Game,角色扮演游戏)模式，
# 玩家可以在游戏中扮演虚拟世界中的一个特定角色，
# 角色根据不同的游戏情节和统计数据（如力量、魔法、技能等）具有不同的能力
# ，角色也会随着不断升级而拥有更加强大的能力。
# 作为RPG游戏的一个重要组成部分，需要对游戏角色进行设计，
# 而且随着该游戏的升级将不断增加新的角色。
# 不同类型的游戏角色，其性别、脸型、服装、发型等外部特性都有所差异，
# 例如“天使”拥有美丽的面容和披肩的长发，并身穿一袭白裙；
# 而“恶魔”极其丑陋，留着光头并穿一件刺眼的黑衣。
# Sunny公司决定开发一个小工具来创建游戏角色，
# 可以创建不同类型的角色并可以灵活增加新的角色。

# 1.参数复杂
# 2.要控制不同的构造顺序,不然没必要用建造者模式

require 'active_support/all'


class Actor

  attr_accessor :type, :sex, :face, :costume, :hairstyle


  # def initialize(attribute)
  #   @attribute = attribute
  # end

  def show
    p "种族：#{type}"
    p "性别：#{sex}"
    p "脸型：#{face}"
    p "服装：#{costume}"
    p "发型：#{hairstyle}"
  end

end

class ActorBuilder
  attr_reader :actor

  def initialize
    @actor = Actor.new
  end

  def method_missing(meth, *args, &blk)
    actor.send(meth, *args, &blk)
  end

end



builder = ActorBuilder.new
builder.sex = '男'
actor = builder.actor
actor.show

p '------------------------'

builder.show
