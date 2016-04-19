import * as jqueryHelpers from "./lib/jquerHelpers";

function one() {
  debugger
}

$('.toggle-menu').on('click', (ev) => {
  // $('.nav').toggleClass('slideInDown', 'slideOutUp')
  // $('.nav').toggleClasses('slideInDown', 'slideOutUp')

  const $this = $('.nav')

  $('body').addClass('.menu-open')

  if ($this.is(':visible')) {
    $('body').removeClass('menu-open')
    $this.animateCss('fadeOutUpBig', true)
  } else {
    $('body').addClass('menu-open')
    $this.show().animateCss('fadeInDownBig')
  }
})

$(window).on('resize', (ev) => {
  const $item = $('.lorem-img')
  $item.height($item.width())
}).trigger('resize')

function greedyJumbotron() {
  var HEIGHT_CHANGE_TOLERANCE = 100

  var jumbotron = $(this)
  var viewportHeight = $(window).height()

  $(window).resize(function () {
    if (Math.abs(viewportHeight - $(window).height()) > HEIGHT_CHANGE_TOLERANCE) {
      viewportHeight = $(window).height()
      update()
    }
  });

  function update() {
    jumbotron.css('height', viewportHeight + 'px')
  }

  update()
}

$('.welcome').each(greedyJumbotron)

function seppl() {
  const thumb = $(this)
  const active = $('.gallery .active')
  const showroom = $('.gallery .picture')
  showroom.css('background-image', `url(${thumb.data('src')})`)
  active.removeClass('active')
  thumb.addClass('active')
}


$('.gallery .thumb').on('click', seppl)


function openProduct(ev) {
  ev.preventDefault()
  const url = $(this).data('target')
  console.log(url)

  $.get(url, (data) => {
    var page = $(data)
    const body = $('body')
    const modal = page.closest('.modal-wrapper')
    modal.removeClass('modal-wrapper').addClass('modal animated bounceInDown')
    body.addClass('modal__open')
    body.append(modal)

    modal.find('.closes').on('click', function(ev) {
      modal.removeClass('bounceInDown')
      modal.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', () => {
        modal.remove()
        body.removeClass('modal__open')
      })
      modal.addClass('bounceOutUp')
    })
  })
}

$('.doit').on('click', openProduct)
