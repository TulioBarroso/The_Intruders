// ===================================================
// THE INTRUDERS
// ===================================================

ArrayList<Inimigo> inimigos = new ArrayList<Inimigo>();
ArrayList<Bala> balas = new ArrayList<Bala>();
ArrayList<EfeitoAcerto> efeitos = new ArrayList<EfeitoAcerto>();
ArrayList<TiroBoss> tirosBoss = new ArrayList<TiroBoss>();

Jogador jogador;

// ===================================================
// SPRITES
// ===================================================

PImage spriteCanhao;
PImage spriteBala;

PImage spriteAcerto1;
PImage spriteAcerto2;

PImage spriteInimigo;
PImage spriteBoss;

PImage spriteTiroBoss;
PImage spriteExplosaoBoss;

PImage fundo;

// ===================================================
// CONTROLES
// ===================================================

boolean esquerdaPressionada = false;
boolean direitaPressionada = false;

// ===================================================
// ESTADOS
// ===================================================

int estadoJogo = 0;

// 0 MENU
// 1 JOGO
// 2 RECORDES
// 3 GAME OVER

// ===================================================
// JOGO
// ===================================================

int pontos = 0;
int recorde = 0;

Boss boss;
boolean bossApareceu = false;

PFont fonte;

// ===================================================

void setup() {

  size(700, 900);

  smooth(8);

  fonte = createFont("Arial", 24);

  textFont(fonte);

  // ===================================================
  // CARREGAR SPRITES
  // ===================================================

  spriteCanhao = loadImage("canhao.png");

  spriteBala = loadImage("bala.png");

  spriteAcerto1 = loadImage("balaacertou.png");
  spriteAcerto2 = loadImage("balaacertou2.png");

  spriteInimigo = loadImage("lacaio.png");

  spriteBoss = loadImage("boss.png");

  spriteTiroBoss = loadImage("tiroboss.png");

  spriteExplosaoBoss = loadImage("tiroboss2.png");

  fundo = loadImage("fundo.png");

  // ===================================================

  jogador = new Jogador();

  carregarRecorde();
}

// ===================================================

void draw() {

  if (estadoJogo == 0) {

    desenharMenu();

  } else if (estadoJogo == 1) {

    rodarJogo();

  } else if (estadoJogo == 2) {

    desenharRecordes();

  } else if (estadoJogo == 3) {

    desenharGameOver();
  }
}

// ===================================================
// MENU
// ===================================================

void desenharMenu() {

  background(10, 15, 30);

  fill(255);

  textAlign(CENTER);

  textSize(58);

  text("THE INTRUDERS", width/2, 140);

  textSize(20);

  fill(180);

  text("Defenda a Terra da invasão!", width/2, 190);

  desenharBotao(width/2 - 140, 260, 280, 65, "JOGAR");

  desenharBotao(width/2 - 140, 350, 280, 65, "VER RECORDES");

  desenharBotao(width/2 - 140, 440, 280, 65, "EXCLUIR RECORDES");

  fill(200);

  textSize(16);

  text("A/D ou SETAS para mover", width/2, 620);
  text("ESPAÇO para atirar", width/2, 650);
}

// ===================================================

void desenharBotao(int x, int y, int w, int h, String textoBotao) {

  boolean mouseSobre =
    mouseX > x &&
    mouseX < x+w &&
    mouseY > y &&
    mouseY < y+h;

  if (mouseSobre) {

    fill(60, 140, 255);

  } else {

    fill(35);
  }

  stroke(255);

  strokeWeight(2);

  rect(x, y, w, h, 15);

  fill(255);

  textSize(24);

  text(textoBotao, x + w/2, y + 42);
}

// ===================================================
// JOGO
// ===================================================

void rodarJogo() {

  // ===================================================
  // FUNDO
  // ===================================================

  background(0);

  imageMode(CORNER);

  float escala = max(
    width / (float) fundo.width,
    height / (float) fundo.height
  );

  float largura = fundo.width * escala;
  float altura = fundo.height * escala;

  image(
    fundo,
    (width - largura)/2,
    (height - altura)/2,
    largura,
    altura
  );

  // ===================================================
  // ESCURECIMENTO
  // ===================================================

  fill(0, 0, 0, 90);

  rect(0, 0, width, height);

  // ===================================================
  // TERRA
  // ===================================================

  noStroke();

  fill(30, 120, 45);

  rect(0, height - 55, width, 55);

  fill(40, 150, 60);

  rect(0, height - 40, width, 40);

  for (int i = 0; i < width; i += 25) {

    fill(50, 170, 70, 120);

    ellipse(i, height - 25, 10, 6);
  }

  // ===================================================
  // SOMBRA
  // ===================================================

  fill(0, 0, 0, 90);

  ellipse(
    jogador.x,
    jogador.y + 40,
    120,
    25
  );

  // ===================================================
  // HUD
  // ===================================================

  fill(255);

  textAlign(LEFT);

  textSize(24);

  text("PONTOS: " + pontos, 20, 40);

  textAlign(RIGHT);

  text("RECORDE: " + recorde, width - 20, 40);

  // ===================================================
  // SPAWN INIMIGOS
  // ===================================================

  if (!bossApareceu) {

    if (frameCount % 42 == 0) {

      inimigos.add(new Inimigo());
    }
  }

  // ===================================================
  // SPAWN BOSS
  // ===================================================

  if (pontos >= 20 && !bossApareceu) {

    boss = new Boss();

    bossApareceu = true;

    inimigos.clear();
  }

  // ===================================================
  // JOGADOR
  // ===================================================

  jogador.update();
  jogador.display();

  // ===================================================
  // BALAS
  // ===================================================

  for (int i = balas.size()-1; i >= 0; i--) {

    Bala bala = balas.get(i);

    bala.update();
    bala.display();

    if (bala.saiuTela()) {

      balas.remove(i);
    }
  }

  // ===================================================
  // EFEITOS
  // ===================================================

  for (int i = efeitos.size()-1; i >= 0; i--) {

    EfeitoAcerto efeito = efeitos.get(i);

    efeito.update();
    efeito.display();

    if (efeito.finalizado()) {

      efeitos.remove(i);
    }
  }

  // ===================================================
  // BOSS
  // ===================================================

  if (bossApareceu && boss != null) {

    boss.update();
    boss.display();

    if (frameCount % 40 == 0) {

      tirosBoss.add(
        new TiroBoss(
          boss.x + random(-90, 90),
          boss.y + 70
        )
      );
    }

    for (int j = balas.size()-1; j >= 0; j--) {

      Bala bala = balas.get(j);

      if (dist(bala.x, bala.y, boss.x, boss.y) < 110) {

        balas.remove(j);

        boss.vida--;

        efeitos.add(
          new EfeitoAcerto(
            boss.x + random(-30, 30),
            boss.y + random(-20, 20)
          )
        );

        if (boss.vida <= 0) {

          pontos += 10;

          if (pontos > recorde) {

            recorde = pontos;

            salvarRecorde();
          }

          telaVitoria();

          return;
        }

        break;
      }
    }
  }

  // ===================================================
  // TIROS BOSS
  // ===================================================

  for (int i = tirosBoss.size()-1; i >= 0; i--) {

    TiroBoss tiro = tirosBoss.get(i);

    tiro.update();
    tiro.display();

    if (tiro.acertouChao()) {

      tiro.explodiu = true;
    }

    if (tiro.finalizado()) {

      tirosBoss.remove(i);
    }

    if (!tiro.explodiu &&
      dist(tiro.x, tiro.y, jogador.x, jogador.y) < 55) {

      gameOver();

      return;
    }
  }

  // ===================================================
  // INIMIGOS
  // ===================================================

  for (int i = inimigos.size()-1; i >= 0; i--) {

    Inimigo inimigo = inimigos.get(i);

    inimigo.update();
    inimigo.display();

    if (inimigo.y > height - 70) {

      gameOver();

      return;
    }

    for (int j = balas.size()-1; j >= 0; j--) {

      Bala bala = balas.get(j);

      if (dist(bala.x, bala.y, inimigo.x, inimigo.y) < 40) {

        efeitos.add(
          new EfeitoAcerto(
            inimigo.x,
            inimigo.y
          )
        );

        inimigos.remove(i);

        balas.remove(j);

        pontos++;

        break;
      }
    }
  }
}

// ===================================================
// RECORDES
// ===================================================

void desenharRecordes() {

  background(20);

  fill(255);

  textAlign(CENTER);

  textSize(52);

  text("RECORDES", width/2, 130);

  textSize(34);

  fill(0, 255, 255);

  text("Maior Pontuação: " + recorde, width/2, 300);

  desenharBotao(width/2 - 140, 450, 280, 65, "VOLTAR");
}

// ===================================================
// GAME OVER
// ===================================================

void desenharGameOver() {

  background(0);

  fill(0, 0, 0, 190);

  rect(0, 0, width, height);

  textAlign(CENTER);

  fill(255, 40, 40);

  textSize(78);

  text("GAME OVER", width/2, height/2 - 140);

  fill(255);

  textSize(30);

  text("A Terra foi invadida", width/2, height/2 - 70);

  fill(0, 255, 255);

  textSize(36);

  text("PONTOS: " + pontos, width/2, height/2 + 20);

  fill(255, 220, 0);

  textSize(28);

  text("RECORDE: " + recorde, width/2, height/2 + 80);

  if (frameCount % 60 < 30) {

    fill(255);

    textSize(24);

    text(
      "PRESSIONE ESPAÇO PARA VOLTAR AO MENU",
      width/2,
      height/2 + 180
    );
  }

  for (int i = 0; i < 80; i++) {

    fill(255, random(40, 150));

    ellipse(
      random(width),
      random(height),
      random(2, 6),
      random(2, 6)
    );
  }
}

// ===================================================
// JOGADOR
// ===================================================

class Jogador {

  float x;
  float y;

  float velocidade = 8;

  Jogador() {

    x = width/2;

    y = height - 105;
  }

  void update() {

    if (esquerdaPressionada) {

      x -= velocidade;
    }

    if (direitaPressionada) {

      x += velocidade;
    }

    x = constrain(x, 70, width - 70);
  }

  void display() {

    imageMode(CENTER);

    image(spriteCanhao, x, y, 150, 150);

    imageMode(CORNER);
  }
}

// ===================================================
// BALA
// ===================================================

class Bala {

  float x;
  float y;

  float velocidade = 15;

  Bala(float x, float y) {

    this.x = x;
    this.y = y;
  }

  void update() {

    y -= velocidade;
  }

  void display() {

    imageMode(CENTER);

    image(spriteBala, x, y, 70, 70);

    imageMode(CORNER);
  }

  boolean saiuTela() {

    return y < -60;
  }
}

// ===================================================
// TIRO BOSS
// ===================================================

class TiroBoss {

  float x;
  float y;

  float velocidade = 8;

  boolean explodiu = false;

  int tempo = 0;

  TiroBoss(float x, float y) {

    this.x = x;
    this.y = y;
  }

  void update() {

    if (!explodiu) {

      y += velocidade;

    } else {

      tempo++;
    }
  }

  void display() {

    imageMode(CENTER);

    if (!explodiu) {

      image(spriteTiroBoss, x, y, 75, 75);

    } else {

      image(spriteExplosaoBoss, x, y, 120, 120);
    }

    imageMode(CORNER);
  }

  boolean acertouChao() {

    return y >= height - 50;
  }

  boolean finalizado() {

    return explodiu && tempo > 14;
  }
}

// ===================================================
// EFEITO ACERTO
// ===================================================

class EfeitoAcerto {

  float x;
  float y;

  int tempo = 0;

  EfeitoAcerto(float x, float y) {

    this.x = x;
    this.y = y;
  }

  void update() {

    tempo++;
  }

  void display() {

    imageMode(CENTER);

    if (tempo < 8) {

      image(spriteAcerto1, x, y, 100, 100);

    } else {

      image(spriteAcerto2, x, y, 130, 130);
    }

    imageMode(CORNER);
  }

  boolean finalizado() {

    return tempo > 16;
  }
}

// ===================================================
// INIMIGO
// ===================================================

class Inimigo {

  float x;
  float y;

  float velocidade;

  float movimentoX;

  Inimigo() {

    x = random(60, width-60);

    y = -40;

    velocidade = random(2.5, 5);

    movimentoX = random(-1.2, 1.2);
  }

  void update() {

    y += velocidade;

    x += movimentoX;

    if (x < 50 || x > width - 50) {

      movimentoX *= -1;
    }
  }

  void display() {

    imageMode(CENTER);

    float balanco = sin(frameCount * 0.15 + x) * 5;

    image(
      spriteInimigo,
      x + balanco,
      y,
      125,
      95
    );

    imageMode(CORNER);
  }
}

// ===================================================
// BOSS
// ===================================================

class Boss {

  float x;
  float y;

  int vida = 15;

  Boss() {

    x = width/2;

    y = 150;
  }

  void update() {

    x += sin(frameCount * 0.04) * 4;
  }

  void display() {

    imageMode(CENTER);

    image(spriteBoss, x, y, 300, 260);

    imageMode(CORNER);

    fill(60);

    rect(width/2 - 155, 42, 310, 30, 10);

    fill(255, 0, 0);

    rect(width/2 - 150, 47, 300, 20, 8);

    fill(0, 255, 255);

    rect(width/2 - 150, 47, vida * 20, 20, 8);

    fill(255);

    textAlign(CENTER);

    textSize(22);

    text("BOSS HP: " + vida, width/2, 32);
  }
}

// ===================================================
// CONTROLES
// ===================================================

void keyPressed() {

  if (key == 'a' || keyCode == LEFT) {

    esquerdaPressionada = true;
  }

  if (key == 'd' || keyCode == RIGHT) {

    direitaPressionada = true;
  }

  // atirar

  if (estadoJogo == 1) {

    if (key == ' ') {

      balas.add(
        new Bala(
          jogador.x,
          jogador.y - 80
        )
      );
    }
  }

  // sair game over

  if (estadoJogo == 3) {

    if (key == ' ') {

      estadoJogo = 0;
    }
  }
}

// ===================================================

void keyReleased() {

  if (key == 'a' || keyCode == LEFT) {

    esquerdaPressionada = false;
  }

  if (key == 'd' || keyCode == RIGHT) {

    direitaPressionada = false;
  }
}

// ===================================================
// MOUSE
// ===================================================

void mousePressed() {

  if (estadoJogo == 0) {

    if (
      mouseX > width/2 - 140 &&
      mouseX < width/2 + 140 &&
      mouseY > 260 &&
      mouseY < 325
      ) {

      iniciarJogo();
    }

    if (
      mouseX > width/2 - 140 &&
      mouseX < width/2 + 140 &&
      mouseY > 350 &&
      mouseY < 415
      ) {

      estadoJogo = 2;
    }

    if (
      mouseX > width/2 - 140 &&
      mouseX < width/2 + 140 &&
      mouseY > 440 &&
      mouseY < 505
      ) {

      recorde = 0;

      salvarRecorde();
    }
  }

  else if (estadoJogo == 2) {

    if (
      mouseX > width/2 - 140 &&
      mouseX < width/2 + 140 &&
      mouseY > 450 &&
      mouseY < 515
      ) {

      estadoJogo = 0;
    }
  }
}

// ===================================================
// INICIAR JOGO
// ===================================================

void iniciarJogo() {

  pontos = 0;

  inimigos.clear();
  balas.clear();
  efeitos.clear();
  tirosBoss.clear();

  boss = null;

  bossApareceu = false;

  jogador = new Jogador();

  estadoJogo = 1;
}

// ===================================================
// GAME OVER
// ===================================================

void gameOver() {

  if (pontos > recorde) {

    recorde = pontos;

    salvarRecorde();
  }

  estadoJogo = 3;
}

// ===================================================
// VITÓRIA
// ===================================================

void telaVitoria() {

  background(5, 20, 40);

  fill(0, 255, 255);

  textAlign(CENTER);

  textSize(74);

  text("VITÓRIA!", width/2, height/2 - 40);

  fill(255);

  textSize(30);

  text("Boss derrotado!", width/2, height/2 + 30);

  delay(3200);

  estadoJogo = 0;
}

// ===================================================
// RECORDES
// ===================================================

void salvarRecorde() {

  String[] dados = {
    str(recorde)
  };

  saveStrings("recorde.txt", dados);
}

// ===================================================

void carregarRecorde() {

  String[] dados = loadStrings("recorde.txt");

  if (dados != null && dados.length > 0) {

    recorde = int(dados[0]);
  }
}
