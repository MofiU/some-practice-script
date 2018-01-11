class Account

  attr_accessor :balance, :owner, :state

  def initialize(owner, balance)
    @owner = owner
    @balance = balance
    @state = NormalState.new(self)
    p "开户成功,持卡人：#{owner}， 账户余额：#{balance}"
  end


  def method_missing(meth, *args, &blk)
    state.send(meth, *args, &blk)
  end


end



class State
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def check_state

  end

  def withdrawal(money)
    account.balance -= money
    check_state
    p "成功取款 ￥#{money},当前余额 ￥#{account.balance}"
  end

  def deposit(money)
    account.balance += money
    check_state
    p "成功存款 ￥#{money}, 当前余额 ￥#{account.balance}"
  end

  def get_balance
    p "当前用户余额：#{account.balance}"
  end

  def method_missing(meth, *args, &blk)
    account.send(meth, *args, &blk)
    check_state
  end

end

class NormalState < State

  def check_state
    if account.balance > -2000 && account.balance < 0
      account.state = OverdraftState.new(account)
    elsif account.balance <= -2000
      account.state = RestrictState.new(account)
    end
  end

end

class OverdraftState < State
  def withdrawal(money)
    p '正处于透支状态，请谨慎取款，小心提刀上门追债'
    super
  end
  def check_state
    if account.balance > 0
      account.state = NormalState.new(account)
    elsif account.balance <= -2000
      account.state = RestrictState.new(account)
    end
  end


end

class RestrictState < State
  def withdrawal(money)
    p '冻结状态不予办理取款业务,三日之内不还钱，必提刀上门 :=)'
  end

  def check_state
    if account.balance > 0
      account.state = NormalState.new(account)
    elsif account.balance > -2000 && account.balance < 0
      account.state = OverdraftState.new(account)
    end
  end
end


liang = Account.new('liang.wang', 5000)


liang.get_balance

liang.deposit(200)

liang.withdrawal(5000)

liang.withdrawal(1000)

liang.withdrawal(500)

liang.withdrawal(5000)

liang.withdrawal(5000)
