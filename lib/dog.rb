class Dog
    attr_accessor :name, :breed, :id

def initialize(name:, breed:, id: nil)

    @id=id
    @name= name
    @breed= breed
    end

    #this is a class method that creates a table called dogs
    def self.create_table
        sql= <<-SQL
        CREATE TABLE IF NOT EXISTS dogs(
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        )
        SQL
        DB[:conn].execute(sql)
    end

    #this is a class method that drops a table
    def self.drop_table
        sql= <<-SQL
        DROP TABLE IF EXISTS dogs
        SQL
        DB[:conn].execute(sql)
    end

    #saves instance of a dog into the database
    def save
        sql= <<-SQL 
        INSERT INTO dogs(name, breed)
        VALUES(?,?)
        SQL
        #insert into dogs
        DB[:conn].execute(sql, self.name, self.breed)

        # get the dog ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    # return the Ruby instance
    self
    end
#this is a class method, it creates an instance of a dog
    def self.create(name:, breed:)
        dog= Dog.new(name: name, breed: breed)
        dog.save
    end

    def self.new_from_db(row)
        self.new(id: row[0], name:row[1], breed:row[2])
    end

    def self.all
        sql= <<-SQL
        SELECT *
        FROM dogs
        SQL
        DB[:conn].execute(sql).map do |row|
            self.new_from_db(row)
        end
    end

    def self.find_by_name(name)
        sql= <<-SQL
        SELECT *
        FROM dogs
        WHERE name= ?
        LIMIT 1
        SQL
        DB[:conn].execute(sql, name).map do |row|
            self.new_from_db(row)
        end.first
        end
def self.find (id)
    sql = <<-SQL
    SELECT * 
    FROM dogs 
    WHERE id=?
    LIMIT 1
    SQL
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
      end.first
end


end
