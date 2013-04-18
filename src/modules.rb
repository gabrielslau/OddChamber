# Organiza os níveis de camadas a serem usados no programa. Cada objeto terá uma camada específica, podendo variar de acordo com a necessidade.
module ZOrder
  Background, BackgroundStuff, Stuff, Player, UI = *0..4
end

module Sfx
	Filelist = {
		# Effects
		:button_negative    => 'Portal2_sfx_button_negative.ogg',
		:button_positive    => 'Portal2_sfx_button_positive.ogg',
		:portal_blue        => 'Portal2_sfx_portal_gun_fire_blue.ogg',
		:portal_orange      => 'Portal2_sfx_portal_gun_fire_orange.ogg',
		:explosion          => 'explosion.wav',
		:collectable        => 'collectable.wav',
		:door_open          => 'Portal2_sfx_door_open.ogg',
		
		# Songs
		:main_menu          => '04 - Main Menu.ogg',
		:gameplay_chamber01 => 'Portal2-03-999999.ogg',
		:credits            => 'Portal2-13-Want_You_Gone.ogg',
	}

	# TODO: incluir recurso de pausar a música
	# PORQUE o Chingu nao tem esse recurso????

    def load_song(sound = nil)
		self.load( sound, '/' )
		# Gosu::Song(SoundDir + '/' + Filelist[sound]) if not sound.nil?
	end

	def load_sfx(sound = nil)
		# Sound[SoundDir+'/sfx/'+ Filelist[sound]] if not sound.nil?
		self.load( sound, '/sfx/' )
	end

	def load(sound = nil, type = '')
		Sound[SoundDir+type+ Filelist[sound]] if not sound.nil?
	end
end