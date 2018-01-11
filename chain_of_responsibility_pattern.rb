# Sunny软件公司承接了某企业SCM(Supply Chain Management，
# 供应链管理)系统的开发任务，其中包含一个采购审批子系统。
# 该企业的采购审批是分级进行的，
# 即根据采购金额的不同由不同层次的主管人员来审批，
# 主任可以审批5万元以下（不包括5万元）的采购单，
# 副董事长可以审批5万元至10万元（不包括10万元）的采购单，
# 董事长可以审批10万元至50万元（不包括50万元）的采购单，
# 50万元及以上的采购单就需要开董事会讨论决定。



class PurchaseRequest

  attr_reader :amount, :purpose, :number

  def initialize(amount, purpose, number)
    @amount, @purpose, @number = amount, purpose, number
  end


end

class Approver
  attr_reader :limit, :request, :level, :name
  attr_accessor :successor

  def initialize(name)
    @name = name
  end

  def process_request(request)
    if request.amount < limit
      p "#{level}:#{name}审批采购单 #{request.number},金额：#{request.amount},用途：#{request.purpose}"
    else
      successor.process_request(request)
    end
  end

end


class Director < Approver
  def initialize(name)
    super
    @limit = 50000
    @level = '主任'
  end
end

class  VicePresident < Approver
  def initialize(name)
    super
    @limit = 100000
    @level = '副董事长'
  end
end

class President < Approver
  def initialize(name)
    super
    @limit = 500000
    @level = '董事长'
  end
end

class Congress  < Approver

  def initialize
    @level = '董事会'
  end

  def process_request(request)
    p "#{level}:#{name}审批采购单 #{request.number},金额：#{request.amount},用途：#{request.purpose}"
  end

end


wjzhang = Director.new('张无忌')
gyang = VicePresident.new('杨过')
xdiao = President.new('雕兄')
rhuang = Congress.new

## 创建职责链
wjzhang.successor = gyang
gyang.successor = xdiao
xdiao.successor = rhuang


request1 = PurchaseRequest.new(45000, '购买倚天剑', 1001)
request2 = PurchaseRequest.new(80000, '购买雕牌洗衣粉', 1002)
request3 = PurchaseRequest.new(120000, '购买宠物粮', 1003)
request4 = PurchaseRequest.new(500000, '购买桃花岛', 1004)

wjzhang.process_request(request1)
wjzhang.process_request(request2)
wjzhang.process_request(request3)
wjzhang.process_request(request4)