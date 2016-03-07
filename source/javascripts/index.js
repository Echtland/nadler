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
