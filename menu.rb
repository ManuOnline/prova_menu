require 'gosu'

module ZOrder
	Sfondo, Picture, Menu, SfondoMenu, SelezioneMenu, Scritte = *0..5
end

class Menu < Gosu::Window

	WHITE = Gosu::Color::WHITE
	GRAY = Gosu::Color::GRAY
	BLACK = Gosu::Color::BLACK
	MENUGRAY = Gosu::Color.argb(0xffe9e9e9)
	SELECTION = Gosu::Color.argb(0xff7da7d9)

	def initialize
		super(640, 640, false)
		self.caption = "Prova di Menu"
		@text = Gosu::Font.new(16)
		@over = :none
		@open = :none
		@over_file = :none
		@over_edit = :none
		@over_about = :none
		@show_selection = false
		@point = Point.new(self, mouse_x, mouse_y)
		@picture = []
	end

	def needs_cursor?
		true
	end

	def update
		if mouse_x.between?(0, 40) && mouse_y.between?(0, 25)
			@over = :file
		elsif mouse_x.between?(40, 80) && mouse_y.between?(0, 25)
			@over = :edit
		elsif mouse_x.between?(80, 130) && mouse_y.between?(0, 25)
			@over = :about
		else
			@over = :none if @open == :none
		end

		if mouse_x.between?(0, 130) && mouse_y.between?(25, 50)
			@over_file = :new_file if @over == :file
		elsif mouse_x.between?(0, 130) && mouse_y.between?(50, 80)
			@over_file = :open_file if @over == :file
		elsif mouse_x.between?(0, 130) && mouse_y.between?(80, 110)
			@over_file = :save if @over == :file
		elsif mouse_x.between?(0, 130) && mouse_y.between?(110, 140)
			@over_file = :save_as if @over == :file
		elsif mouse_x.between?(0, 130) && mouse_y.between?(140, 170)
			@over_file = :exit if @over == :file
		else
			@over_file = :none
		end

		if mouse_x.between?(40, 120) && mouse_y.between?(25, 50)
			@over_edit = :undo if @over == :edit
		elsif mouse_x.between?(40, 120) && mouse_y.between?(50, 80)
			@over_edit = :repeat if @over == :edit
		else
			@over_edit = :none
		end

		if mouse_x.between?(80, 350) && mouse_y.between?(25, 50)
			@over_about = :author if @over == :about
		elsif mouse_x.between?(80, 350) && mouse_y.between?(50, 80)
			@over_about = :show_coord if @over == :about
		else 
			@over_about = :none
		end


		if @open == :none && @over == :none
			if button_down?(Gosu::MsLeft)
				@picture.push Point.new(self, mouse_x, mouse_y)
			end
		end
	end

	def draw
		self.draw_quad(0, 0, WHITE, 640, 0, WHITE, 640, 640, WHITE, 0, 640, WHITE, ZOrder::Sfondo)
		@text.draw("Left Click: write", 265, 30, ZOrder::Menu, 1, 1, BLACK)
		@text.draw("Right Click: cancel", 255, 60, ZOrder::Menu, 1, 1, BLACK)
		self.draw_quad(0, 0, WHITE, 640, 0, WHITE, 640, 25, GRAY, 0, 25, GRAY, ZOrder::Menu)
		
		@text.draw("File", 	10, 5, ZOrder::Scritte, 1, 1, BLACK)
		@text.draw("Edit", 	45, 5, ZOrder::Scritte, 1, 1, BLACK)
		@text.draw("About", 85, 5, ZOrder::Scritte, 1, 1, BLACK)

		self.draw_quad(0, 0, GRAY, 40, 0, GRAY, 40, 25, WHITE, 0, 25, WHITE, ZOrder::SfondoMenu) if @over == :file
		self.draw_quad(40, 0, GRAY, 80, 0, GRAY, 80, 25, WHITE, 40, 25, WHITE, ZOrder::SfondoMenu) if @over == :edit
		self.draw_quad(80, 0, GRAY, 130, 0, GRAY, 130, 25, WHITE, 80, 25, WHITE, ZOrder::SfondoMenu) if @over == :about

		if @open != :none && @over == :file
			self.draw_quad(0, 25, MENUGRAY, 130, 25, MENUGRAY, 130, 170, MENUGRAY, 0, 170, MENUGRAY, ZOrder::SfondoMenu)

			@text.draw("New file", 	10, 30, ZOrder::Scritte, 1, 1, BLACK)
			@text.draw("Open file...", 			10, 60, ZOrder::Scritte, 1, 1, BLACK)
			@text.draw("Save", 	10, 90, ZOrder::Scritte, 1, 1, BLACK)
			@text.draw("Save as...", 			10, 120, ZOrder::Scritte, 1, 1, BLACK)
			@text.draw("Exit", 			10, 150, ZOrder::Scritte, 1, 1, BLACK)

			self.draw_quad(0, 25, SELECTION, 130, 25, SELECTION, 130, 50, SELECTION, 0, 50, SELECTION, ZOrder::SelezioneMenu) if @over_file == :new_file
			self.draw_quad(0, 50, SELECTION, 130, 50, SELECTION, 130, 80, SELECTION, 0, 80, SELECTION, ZOrder::SelezioneMenu) if @over_file == :open_file
			self.draw_quad(0, 80, SELECTION, 130, 80, SELECTION, 130, 110, SELECTION, 0, 110, SELECTION, ZOrder::SelezioneMenu) if @over_file == :save
			self.draw_quad(0, 110, SELECTION, 130, 110, SELECTION, 130, 140, SELECTION, 0, 140, SELECTION, ZOrder::SelezioneMenu) if @over_file == :save_as
			self.draw_quad(0, 140, SELECTION, 130, 140, SELECTION, 130, 170, SELECTION, 0, 170, SELECTION, ZOrder::SelezioneMenu) if @over_file == :exit
		end

		if @open != :none && @over == :edit
			self.draw_quad(40, 25, MENUGRAY, 120, 25, MENUGRAY, 120, 80, MENUGRAY, 40, 80, MENUGRAY, ZOrder::SfondoMenu)

			@text.draw("Undo", 	 50, 30, ZOrder::Scritte, 1, 1, BLACK)
			@text.draw("Repeat", 50, 60, ZOrder::Scritte, 1, 1, BLACK)

			self.draw_quad(40, 25, SELECTION, 120, 25, SELECTION, 120, 50, SELECTION, 40, 50, SELECTION, ZOrder::SelezioneMenu) if @over_edit == :undo
			self.draw_quad(40, 50, SELECTION, 120, 50, SELECTION, 120, 80, SELECTION, 40, 80, SELECTION, ZOrder::SelezioneMenu) if @over_edit == :repeat
		end

		if @open != :none && @over == :about
			self.draw_quad(80, 25, MENUGRAY, 350, 25, MENUGRAY, 350, 80, MENUGRAY, 80, 80, MENUGRAY, ZOrder::SfondoMenu)
			self.draw_triangle(320, 60, BLACK, 325, 65, BLACK, 320, 69, BLACK, ZOrder::Scritte)

			@text.draw("Barra del menu realizzata da Manu ;)", 90, 30, ZOrder::Scritte, 1, 1, BLACK)
			@text.draw("Show mouse X, Y: ", 90, 60, ZOrder::Scritte, 1, 1, BLACK)

			if @over_about == :author
				self.draw_quad(80, 25, SELECTION, 350, 25, SELECTION, 350, 50, SELECTION, 80, 50, SELECTION, ZOrder::SelezioneMenu)
				@show_selection = false
			end
			self.draw_quad(80, 50, SELECTION, 350, 50, SELECTION, 350, 80, SELECTION, 80, 80, SELECTION, ZOrder::SelezioneMenu) if @over_about == :show_coord
			@show_selection = true if @over_about == :show_coord

			if @show_selection == true
				self.draw_quad(350, 50, MENUGRAY, 450, 50, MENUGRAY, 450, 110, MENUGRAY, 350, 110, MENUGRAY, ZOrder::SfondoMenu)
				@text.draw("Yes", 360, 60, ZOrder::Scritte, 1, 1, BLACK)
				@text.draw("No", 360, 90, ZOrder::Scritte, 1, 1, BLACK)

				if mouse_x.between?(350, 450) && mouse_y.between?(50, 80)
					self.draw_quad(350, 50, SELECTION, 450, 50, SELECTION, 450, 80, SELECTION, 350, 80, SELECTION, ZOrder::SelezioneMenu)
				elsif mouse_x.between?(350, 450) && mouse_y.between?(80, 110)
					self.draw_quad(350, 80, SELECTION, 450, 80, SELECTION, 450, 110, SELECTION, 350, 110, SELECTION, ZOrder::SelezioneMenu)
				end
			end
		end

		@picture.each do |point|
			point.draw
		end

		if button_down?(Gosu::MsRight)
			self.draw_quad(mouse_x-8, mouse_y-8, Gosu::Color::BLACK, mouse_x+8, mouse_y-8, Gosu::Color::BLACK, mouse_x+8, mouse_y+8, Gosu::Color::BLACK, mouse_x-8, mouse_y+8, Gosu::Color::BLACK, ZOrder::Picture)
			self.draw_quad(mouse_x-7, mouse_y-7, Gosu::Color::WHITE, mouse_x+7, mouse_y-7, Gosu::Color::WHITE, mouse_x+7, mouse_y+7, Gosu::Color::WHITE, mouse_x-7, mouse_y+7, Gosu::Color::WHITE, ZOrder::Picture)
			@picture.each do |point|
				distance = Gosu.distance(mouse_x, mouse_y, point.x, point.y)
				if distance < 8
					@picture.delete point
				end
			end
		end

	end

	def button_down(id)
		if id == Gosu::MsLeft
			puts "X: #{mouse_x}, Y: #{mouse_y}" if @show_coord == true
			if mouse_x.between?(0, 40) && mouse_y.between?(0, 25) && @open == :none
				@open = :file
				@over = :file
			elsif mouse_x.between?(40, 80) && mouse_y.between?(0, 25) && @open == :none
				@open = :edit
				@over = :edit
			elsif mouse_x.between?(80, 130) && mouse_y.between?(0, 25) && @open == :none
				@open = :about
				@over = :about
			else 
				@open = :none
				@over = :none
			end

			if @over_file == :exit
				close
			elsif @over_file == :new_file
				puts "Should create a new file..."
			elsif @over_file == :open_file
				puts "Should open a file..."
				@over_file = :none
			elsif @over_file == :save
				puts "Should save the file..."
				@over_file = :none
			elsif @over_file == :save_as
				puts "Should save as..."
				@over_file = :none
			elsif @over_edit == :undo
				puts "Should undo..."
				@over_edit = :none
			elsif @over_edit == :repeat
				puts "Should repeat..."
				@over_edit = :none
			elsif @over_about == :author
				puts "Should show the author..."
				@over_about = :none
			elsif mouse_x.between?(350, 450) && mouse_y.between?(50, 80)
				@show_coord = true
			elsif mouse_x.between?(350, 450) && mouse_y.between?(80, 110)
				@show_coord = false
			end
		end
	end

end

class Point

	attr_reader :x, :y

	def initialize(window, x, y)
		@window = window
		@x = @window.mouse_x
		@y = @window.mouse_y
	end

	def update
		@x = @window.mouse_x
		@y = @window.mouse_y
	end

	def draw
		@window.draw_quad(@x-3, @y-3, Gosu::Color::BLACK, @x+3, @y-3, Gosu::Color::BLACK, @x+3, @y+3, Gosu::Color::BLACK, @x-3, @y+3, Gosu::Color::BLACK, ZOrder::Picture)
	end
end
window = Menu.new.show