require_relative '../spec_helper'

describe TinyORM::Query::Base do
  def sanitize(sql)
    sql.gsub(/\s+/, ' ').strip
  end

  let(:base) { described_class.new(TinyORM::Query::Container.new('users')) }

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
      base.select('AVG(weight)', :height)
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
              SELECT friends.age, friends.name
              FROM users
              INNER JOIN friends ON users.id = friends.user_id
              WHERE (users.id = 1) AND (friends.age > 15)
SQL

    expect(
        base.select('friends.age', 'friends.name')
            .join(:friends)
            .where(id: 1).and('friends.age > 15').to_sql
    ).to eq(sanitize(sql))
  end

end
