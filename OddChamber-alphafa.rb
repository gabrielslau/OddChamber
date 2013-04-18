#!/usr/bin/env ruby
# Carrega as "gemas" necessárias para roda a aplicação
require "rubygems" rescue nil
#require "bundler"
#require 'bundler/setup'
#begin
#  Bundler.setup(:default, :development)
#rescue Bundler::BundlerError => e
#  $stderr.puts e.message
#  $stderr.puts "Run `bundle install` to install missing gems"
#  exit e.status_code
#end
#Bundler.require


ROOT_PATH = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH << '.'
# $LOAD_PATH.unshift File.join(File.expand_path(__FILE__), ".")
ENV['PATH'] = File.join(ROOT_PATH) + ";" + ENV['PATH']

require 'gosu'
require 'chingu'
require 'texplay'

include Gosu
include Chingu

ScreenWidth  = 1024 # 16 * 64 (32 * 32)
ScreenHeight = 640 # 10 * 64 (63 * 32)

# ScreenWidth  = 64 * 6
# ScreenHeigth = 64 * 6

TileSize     = 32
DEBUG        = true

ImageDir = "graphics"
SoundDir = "sounds"
FontDir  = "fonts"

FontSrc = FontDir+'/Fabada-regular.ttf'
# FontSrc = FontDir+'/MAKISUPA.TTF'
 

# Caminho personalizado para imagens, sons, etc
# ----------------------------------------------
Gosu::Image.autoload_dirs.unshift File.join(ROOT_PATH, ImageDir)
Gosu::Sound.autoload_dirs.unshift File.join(ROOT_PATH, SoundDir)
Gosu::Font.autoload_dirs.unshift  File.join(ROOT_PATH, FontDir)

# Carrega todos os objetos do jogo
require_all File.join(ROOT, 'src')

# exit if defined?(Ocra)
begin
  GameWindow.new.show
rescue Exception => e
  f = File.new("error.log", "w+")
  f.puts e.inspect
  f.puts e.backtrace
end