require_relative '../../spec_helper'

describe TinyORM::Query::Get do
  def sanitize(sql)
    sql.gsub(/\s+/, ' ').strip
  end

  let(:get) { described_class.new(TinyORM::Query::Get::Builder.new(User)) }

  it do
    sql = <<SQL
              SELECT AVG(weight), users.height
              FROM users
              WHERE (users.age = 12) AND (weight > 40)
              GROUP BY users.height
              HAVING (height > 150)
              ORDER BY users.height
              LIMIT 10
              OFFSET 2
SQL

    expect(
      get.select('AVG(weight)', :height)
          .where(:age => 12).and('weight > 40')
          .group(:height)
          .having('height > 150')
          .order(:height)
          .limit(10)
          .offset(2).to_sql
    ).to eq(sanitize(sql))
  end

  it do
    sql = <<SQL
              SELECT not_enemies.age, not_enemies.name
              FROM users
              INNER JOIN not_enemies ON users.id = not_enemies.user_id
              WHERE (users.id = 1) AND (not_enemies.age > 15)
SQL

    expect(
        get.select('not_enemies.age', 'not_enemies.name')
            .join(:friends)
            .where(id: 1).and('not_enemies.age > 15').to_sql
    ).to eq(sanitize(sql))
  end

end
