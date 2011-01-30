# -*- coding: utf-8 -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Politic.create({ :name=>'Письменный Данил Викторович', :title=>'Президент ассоциации микроблоггеров Чувашской республики', :desc=>'This file should contain all the record creation needed to seed the database with its default values. The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).' })

# BlogSource.create({:author=>'Данил Письменный', :name=>'Данил Письменный', :link=>'http://dapi.livejournal.com/data/rss'})
# BlogSource.create({:author=>'Этнер Егоров', :name=>'Этнер Егоров', :link=>'http://atner.livejournal.com/data/rss'})

blogs = %w(
          4ichili
a_b_belov
abm05
aciden
al_thebest 
alcomp81
aleks21rus
alenalaskina
alexey_donskoy
angrygoddess
anticor-21
aofedorov
aprelka_nas_ten
araslan
artlin 
atner
avtaurus
baryshov 
bazeboo
blackfox-lola
blizzard_87
borisvorotnikov
bryzgi_dreams
by_la
celt-tv
cheboksarka
chesanny
chuvashiya
chuvashsky
crazyfane
dapi
darina-lilu
deuxjj
dima_cheeze
dmitrydonskov
dmlyamov
dobrograd
domsb
doroteya-greig
dront
elenkache
emelyanov-a
fishmen_che 
fotomm
galo4kin
greblin_jr
greybee
hovglu
ice-below
ideafix_me
ipse_sponte
ira_pavlova 
izbircom21
izlobna9
johnfil
katachita
kav2009
kipek
kotabarsik
kotegof
kpox_kpoxa
kudryavyjandrey
kulagin-a-b
kulturnik
kuroga
kyrecu
l0gin_of
leamurcheg
login_of
lovezsweetest
lvoha
lybr_lubr
lysek911
m_vazicova 
mal61sh
mandryukov
marizet
mary_yu
maxboozegenie
milli_one
mj_live
mmullina
mpa3b_rus21
natkey
nbchr-sovmolod
ne-krya
nenilina
neochapay
neschukar
ni4ka_nosferatu
nisean
null21
olgactc
oracular-oleg
pogovarivaut
pritisk
radonis
randoom
ritakirillova
schukar
scion_of_trust 
serge_ivanov
sergey-creative
shi_maru
shipilevsky
sir_scahr
solovjovnikolay
tamarisque
to-aglaja
ubasi
udikov
uglu
uliana
ulkucular
ulya_solnce
urzukov
velotatyen
vikotoria
vodoleika52
vsegorov
vterentiev
xrenb
yarmoshuk
yenyasinn
yolka_13
z_alexey
zhenya-fedorova
zhivoj_blog
zlobnaya_tetka
zorych
zsweetest
mx900
anggelikka
alex_stasy
pavlovartem
waterzz
rendi-3d
)


# blogs.each do |blog|
#   rss = "http://#{blog}.livejournal.com/data/rss"
#   link = "http://#{blog}.livejournal.com/"
#   Blog.create({:author=>blog, :name=>blog, :link=>rss, :rss_link=>rss}) unless Blog.find_by_link(link)
# end

Blog.create( :author => 'irarura',
             :link => 'http://infohappy.ru/',
             :rss_link => 'http://infohappy.ru/feed/rss',
             :title => 'InfoHappy.ru' )
