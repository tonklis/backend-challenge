class Utils
  def self.shortest_path(paths)
    if paths.empty?
      return paths
    elsif paths.size == 1
      return paths.first
    else
      return paths.sort{|x,y| x.size <=>  y.size}.first
    end
  end
end
