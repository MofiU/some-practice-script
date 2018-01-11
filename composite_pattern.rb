
  #Sunny软件公司欲开发一个杀毒(AntiVirus)软件，
  #该软件既可以对某个文件夹(Folder)杀毒，也可以对某个指定的文件(File)进行杀毒。
  #该杀毒软件还可以根据各类文件的特点，为不同类型的文件提供不同的杀毒方式，
  #例如图像文件(ImageFile)和文本文件(TextFile)的杀毒方式就有所差异。
  #现需要提供该杀毒软件的整体框架设计方案。

class AbstractFile
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def add(file)
    raise "无效方法"
  end

  def remove(file)
    raise "无效方法"
  end

  def get_child(index)
    raise "无效方法"
  end

  def kill_virus
    raise
  end

end

class ImageFile < AbstractFile


  def kill_virus
    p "-----对图像文件#{name}进行杀毒"
  end

end

class TextFile < AbstractFile

  def kill_virus
    p "-----对文本文件#{name}进行杀毒"
  end

end

class VideoFile < AbstractFile

  def kill_virus
    p "-----对视频文件#{name}进行杀毒"
  end

end

class Folder < AbstractFile
  attr_reader :file_list

  def initialize(name)
    super
    @file_list = []
  end

  def add(file)
    if @file_list.include?(file)
      p "文件已存在"
    else
      @file_list << file
      p "文件夹#{name}添加文件#{file.name}成功"
    end
  end

  def remove(file)
    @file_list.delete(file)
    p "移除文件#{file.name}成功"
  end

  def get_child(index)
    file_list[index]
  end

  def kill_virus
    p "-----对文件夹#{name}进行杀毒"
    file_list.each do |file|
      file.kill_virus
    end
  end

end


folder1 =  Folder.new('金庸名著')
folder2 =  Folder.new('小电影')

text1 = TextFile.new('神雕侠侣')
text2 = TextFile.new('射雕英雄传')

image1 = ImageFile.new('小龙女')
image2 = ImageFile.new('杨过')

video1 = VideoFile.new('3D肉蒲团')
video2 = VideoFile.new('3D肉蒲团续')

folder1.add(text1)
folder1.add(text2)
folder1.add(image1)
folder1.add(image2)
folder1.add(image2)
folder1.kill_virus


folder2.add(video1)
folder2.add(video2)
folder2.add(video2)
folder2.add(text1)
folder2.remove(text1)
folder2.kill_virus