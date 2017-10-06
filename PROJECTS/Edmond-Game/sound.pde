float bgmVolume = 1;
float seVolume = 1;
SoundFile bgm;
  SoundFile getSound(String fileName){
    return new SoundFile(game.this,fileName);
  }
  void playBgm(String fileName){
    try{
      if(bgm != null){
        bgm.stop();
      }
      bgm = getSound(fileName);
      refreshBgmVolume();
      if(muted){
        bgmMute();
      }
      bgm.loop();
    }
    catch(NullPointerException e){
      //if(!fileName.equals("error.mp3")){
        //playBgm("error.mp3");
      //}
    }
  }
  void refreshBgmVolume(){
    if(bgm != null){
    bgm.amp(bgmVolume);
    }
  }
  void bgmMute(){
    if(bgm != null){
      bgm.amp(0);
    }
  }
  void playSe(String fileName){
    try{
      if(!muted){
        SoundFile x = getSound(fileName);
        x.amp(seVolume);
        x.play();
      }
    }
    catch(NullPointerException e){
      return;
    }
  }
  