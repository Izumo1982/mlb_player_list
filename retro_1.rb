class SQL
  def initialize(table)
    @table = table
  end

  def conversion_string(v)
    v.map! {|str| str.class == String ? "'#{str}'" : str } 
    v.join', '
  end

  def create(v)
    "INSERT INTO #{@table} VALUES(#{conversion_string(v)});"
  end

  def read(conditions, value = "*")
		value = value.join(', ') if value != "*"
    "SELECT #{value} FROM #{@table} #{where(conditions)};"
  end

  def update(conditions, value)
    "UPDATE #{@table} SET #{set_values(value)} #{where(conditions)};"
  end

  def delete(conditions)
    "DELETE from #{@table} #{where(conditions)};"
  end

  def set_values(h)
    eq(h)
  end

  def eq(h)
    str = ""
    h.each  {|key, value|  str = "#{str}#{key} = '#{value}', "}
    return str[0..-3]
  end

  def into_and(h)
    str = ""
    h.each  {|key, value|  str = "#{str}#{key} = '#{value}' AND "}
    return str[0..-6]# 最後のANDを消す
  end


  def where(h)
    return nil if h == ""
    "where #{into_and(h)}"
  end


end


# 例
mlb_player = SQL.new("player")

list = File.open('mlb_list.txt').readlines
title = list[0].split(',')
list.shift
list.each {|str|
  p mlb_player.create(str.gsub("\n","").split(','))
  gets
}
