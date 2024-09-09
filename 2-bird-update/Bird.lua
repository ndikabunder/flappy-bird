-- Membuat class bird
Bird = Class {}

-- Membuat fungsi ini inisiasi class Bird
function Bird:init()
    -- Memanggil gambar
    self.image = love.graphics.newImage('bird.png')
    -- Membuat lebar bird sesuai gambar
    self.width = self.image:getWidth()
    -- Membuat tinggi bird sesuai gambar
    self.height = self.image:getHeight()

    -- Menentukan letak bird disumbu x ketika ditampilak pertama dilayar
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    -- Menentukan letak bird disumbu y ketika ditampilak pertama dilayar
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end

-- Membuat fungsi menampilkan bird
function Bird:render()
    -- Membuat fungsi menampilkan bird
    love.graphics.draw(self.image, self.x, self.y)
end
