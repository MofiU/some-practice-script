# Sunny软件公司欲开发一个系统运行日志记录器(Logger)，
# 该记录器可以通过多种途径保存系统的运行日志，
# 如通过文件记录或数据库记录，用户可以通过修改配置文件灵活地更换日志记录方式。
# 在设计各类日志记录器时，Sunny公司的开发人员发现需要对日志记录器进行一些初始化工作，
# 初始化参数的设置过程较为复杂，而且某些参数的设置有严格的先后次序，
# 否则可能会发生记录失败。
# 如何封装记录器的初始化过程并保证多种记录器切换的灵活性是Sunny公司开发人员面临的一个难题。

require 'active_support/all'
class MLogger
  def write_log
    raise
  end
end


class FileLogger < MLogger
  def write_log
    p '系统日志记录'
  end
end

class DatabaseLogger < MLogger
  def write_log
    p '数据库日志记录'
  end
end

class LoggerFactory
  def self.create_logger(type)
    const_get("#{type.classify}Logger").new
  end
end


logger = LoggerFactory.create_logger('file')
logger.write_log
logger = LoggerFactory.create_logger('database')
logger.write_log