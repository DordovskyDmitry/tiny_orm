class String
  include TinyORM::PluralSingular

  def camelize
    self.split('_').map(&:capitalize).join
  end

  def underscore
    scan = self.match(/\A[a-z]+\z/i) && self.scan(/[A-Z]+[a-z]*/)
    (scan && scan.any?) ? scan.map(&:downcase).join('_') : self
  end

  def constantize
    Object.const_get(self)
  end
end
