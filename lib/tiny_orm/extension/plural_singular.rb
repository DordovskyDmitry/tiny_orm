module TinyORM
  module PluralSingular

    # Rules was stolen from inflector gem
    PLURALIZE_RULES = {
        /([sxz]|[cs]h)$/i => '\1es',
        /([^aeiouy]o)$/i => '\1es',
        /([^aeiouy])y$/i => '\1ies',
        /$/ => 's'
    }

    SINGULARIZE_RULES = {
        /([^aeiouy])ies$/i => '\1y',
        /([^aeiouy]o)es$/ => '\1',
        /([sxz]|[cs]h)es$/ => '\1',
        /(ss)$/i => '\1',
        /s$/i => ''
    }

    CONSTANT = %w(series species sheep fish deer species aircraft news darts billiards trousers jeans glasses)

    IRREGULAR = {
        'analysis' => 'analyses',
        'axis' => 'axes',
        'cactus' => 'cacti',
        'child' => 'children',
        'crisis' => 'crises',
        'criterion' => 'criteria',
        'datum' => 'data',
        'diagnosis' => 'diagnoses',
        'elf' => 'elves',
        'focus' => 'foci',
        'foot' => 'feet',
        'fungus' => 'fungi',
        'genesis' => 'geneses',
        'goose' => 'geese',
        'half' => 'halves',
        'index' => 'indices',
        'knife' => 'knives',
        'leaf' => 'leaves',
        'life' => 'lives',
        'loaf' => 'loaves',
        'man' => 'men',
        'matrix' => 'matrices',
        'mouse' => 'mice',
        'nemesis' => 'nemeses',
        'nucleus' => 'nuclei',
        'oasis' => 'oases',
        'phenomenon' => 'phenomena',
        'person' => 'people',
        'potato' => 'potatoes',
        'radius' => 'radii',
        'self' => 'selves',
        'testis' => 'testes',
        'thesis' => 'theses',
        'tomato' => 'tomatoes',
        'tooth' => 'teeth',
        'vertex' => 'vertices',
        'wife' => 'wives',
        'woman' => 'women'
    }

    def pluralize
      return self if CONSTANT.include?(self) || IRREGULAR.values.include?(self)
      return IRREGULAR[self] if IRREGULAR.keys.include?(self)
      transform_using(PLURALIZE_RULES)
    end

    def singularize
      return self if CONSTANT.include?(self) || IRREGULAR.keys.include?(self)
      return IRREGULAR.invert[self] if IRREGULAR.values.include?(self)
      transform_using(SINGULARIZE_RULES)
    end

    private

    def transform_using(rules)
      regexp, substitution = rules.detect { |k, _| self =~ k }
      regexp ? self.sub(regexp, substitution) : self
    end
  end
end
