export function toggleClasses(class1, class2){
  if( !class1 || !class2 )
    return this

  return this.each(function(){
    var $elm = $(this)

    if( $elm.hasClass(class1) || $elm.hasClass(class2) )
      $elm.toggleClass(class1 +' '+ class2)

    else
      $elm.addClass(class1)
  })
}

function animateCss(animationName, hide) {
  const animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend'

  function removeClass() {
    $(this).removeClass('animated ' + animationName)
    if (hide) $(this).hide()
  }



  $(this).addClass('animated ' + animationName).one(animationEnd, removeClass)
}

$.fn.extend({
    animateCss: animateCss,
    toggleClasses: toggleClasses
});
