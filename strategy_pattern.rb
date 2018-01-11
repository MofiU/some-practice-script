# Sunny软件公司为某电影院开发了一套影院售票系统，在该系统中需要为不同类型的用户提供不同的电影票打折方式，具体打折方案如下：
# (1) 学生凭学生证可享受票价8折优惠；
# (2) 年龄在10周岁及以下的儿童可享受每张票减免10元的优惠（原始票价需大于等于20元）；
# (3) 影院VIP用户除享受票价半价优惠外还可进行积分，积分累计到一定额度可换取电影院赠送的奖品。
# 该系统在将来可能还要根据需要引入新的打折方式。




class Ticket

  attr_accessor :price, :discount

  def initialize(price)
    @price = price
  end

  def sell
    p "电影票售价:#{discount.calculate(price)}"
  end

  def sell2(&blk)
    p '采用block方式'
    p "电影票售价：#{blk.call(price)}"
  end
end


class Discount

  def calculate(price)
    raise
  end

end

class StudentDiscount < Discount

  def calculate(price)
    p '学生票'
    price*0.8
  end

end


class ChildDiscount < Discount
  def calculate(price)
    p '儿童票'
    price >= 20 ? (price - 10) : price
  end

end

class VipDiscount < Discount

  def calculate(price)
    p 'vip票'
    p '增加积分'
    price*0.5
  end

end


ticket = Ticket.new(100)


ticket.discount = StudentDiscount.new
ticket.sell

ticket.discount = ChildDiscount.new
ticket.sell

ticket.discount = VipDiscount.new
ticket.sell


ticket.sell2{ |price| price*0.2 }