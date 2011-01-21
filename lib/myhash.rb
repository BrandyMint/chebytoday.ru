class Hash
  def rename(f,t)
    self[t]=self[f]
    self.delete f
  end
end
