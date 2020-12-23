// Viewport title
let title = document.getElementById("title")
let follow = document.getElementById("follow")
if (window.matchMedia('(min-width: 640px)').matches) {

} else {
  title.innerHTML = "DSC"
  follow.innerHTML = `<img class="twitter" src="./assets/twitter.svg" alt="Logo de Twitter"><b>@dsc_granada</b></a>`
}

// CTA Scroll

const cta = document.getElementById("cta")
cta.addEventListener("click", (ev) => {
  var elmnt = document.getElementById("scrollHere");
  elmnt.scrollIntoView();
})

const formButton = document.querySelector("#button");
const form = document.querySelector("#core-team-form");

const onSubmit = () => {
  formButton.textContent = "¡Gracias!";
  formButton.setAttribute("disabled", "true");
  alert("Se ha enviado la solicitud correctamente, te contactaremos por email dentro de poco!")
};


// Animacion del header
var TxtRotate = function (el, toRotate, period) {
  this.toRotate = toRotate;
  this.el = el;
  this.loopNum = 0;
  this.period = parseInt(period, 10) || 2000;
  this.txt = '';
  this.tick();
  this.isDeleting = false;
};

TxtRotate.prototype.tick = function () {
  var i = this.loopNum % this.toRotate.length;
  var fullTxt = this.toRotate[i];

  if (this.isDeleting) {
    this.txt = fullTxt.substring(0, this.txt.length - 1);
  } else {
    this.txt = fullTxt.substring(0, this.txt.length + 1);
  }

  this.el.innerHTML = '<span class="wrap">' + this.txt + '</span>';

  var that = this;
  var delta = 100 - Math.random() * 100;

  if (this.isDeleting) {
    delta /= 2;
  }

  if (!this.isDeleting && this.txt === fullTxt) {
    delta = this.period;
    this.isDeleting = true;
  } else if (this.isDeleting && this.txt === '') {
    this.isDeleting = false;
    this.loopNum++;
    delta = 500;
  }

  setTimeout(function () {
    that.tick();
  }, delta);
};

window.onload = function () {
  var elements = document.getElementsByClassName('txt-rotate');
  for (var i = 0; i < elements.length; i++) {
    var toRotate = elements[i].getAttribute('data-rotate');
    var period = elements[i].getAttribute('data-period');
    if (toRotate) {
      new TxtRotate(elements[i], JSON.parse(toRotate), period);
    }
  }
  // INJECT CSS
  var css = document.createElement("style");
  css.type = "text/css";
  css.innerHTML = ".txt-rotate > .wrap { border-right: 0.08em solid #666 }";
  document.body.appendChild(css);
};

// Send data

let sendButton = document.getElementById('button')
sendButton.addEventListener('click', async () => {
  //   let name = document.getElementById("name").value
  //   let email = document.getElementById("email").value
  //   const rawResponse = await fetch('https://send.pageclip.co/5ND4SPBvq44sUgPOMF82SoR0KPtEJWph', {
  //     method: 'POST',
  //     headers: {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json'
  //     },
  //     body: JSON.stringify({
  //       name: 'andres',
  //       email: 'test@email.com'
  //     })
  //   });
  //   const content = await rawResponse.json();

  // console.log(content);
})