

module Observer

  attr_reader :observers

  def initialize
    @observers = []
  end

  def <<(observer)
    @observers << observer
  end

  def delete(observer)
    @observer.delete(observer)
  end

  def notify_observers(message)
    observers.each do |observer|
      observer.update(message)
    end
  end
end

class Player
  include Observer
  attr_reader :name

  def initialize(name)
    super()
    @name = name
  end

  def help
    notify_observers("#{name}需要帮助")
  end

  def update(message)
    p "检测到#{message}, #{name}回复：关我毛事"
  end

end


player1 = Player.new('liang.wang')
player2 = Player.new('chi')

player1.observers << player2
player1.help