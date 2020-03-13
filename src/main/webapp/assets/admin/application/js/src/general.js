/**
 * --------------------------------------------------------------------------
 * Ace (v2.1.0): general.js
   General Ace Function
*/

import $ from 'jquery'
// import bootstrap from 'bootstrap'
import Util from './util'

class Basic {
  static _HandleBasics () {
    Basic._handleAlerts()
    Basic._handleDropdowns()
    Basic._handleNavbar()
    Basic._handleTabScroll()
    Basic._handleScrollTop()

    Basic._handleSticky()
    Basic._handleOther()
  }

  static _handleAlerts () {
    // collapse alert instead of fading it out
    $(document).on('close.bs.alert.alert-collapse', '.alert.alert-collapse', function (e) {
      e.preventDefault()
      $(this).wrap('<div class="collapse show alert-collapse"></div>').parent().collapse('hide').one('hidden.bs.collapse', function () {
        $(this).remove()
      })
    })
  }

  static _handleDropdowns () {
    // hide dropdown when clicked on an element inside it with "data-dismiss=dropdown" attr
    $(document).on('click', '[data-dismiss=dropdown]', function (e) {
      $(e.target).closest('.dropdown-menu').removeClass('show').parent().removeClass('show')
    })

    // don't hide dropdown when clicked inside a .dropdown-clickable element
    $(document).on('click.dropdown-clickable', '.dropdown-clickable', function (e) {
      e.stopImmediatePropagation()
    })
  }

  static _handleNavbar () {
    // hide navbar-collapse when clicked on it (i.e. the backdrop)
    $(document).on('click', '.navbar-backdrop.show', function (e) {
      if (e.target === this) $(this).collapse('hide')
    })

    var hideBodyScrollbar = false
    $('.navbar-collapse')
      .on('shown.bs.collapse', function () {
        hideBodyScrollbar = false

        // move focus to it
        $(this).find('.autofocus').focus()

        if (this.classList.contains('navbar-backdrop')) {
          var scrollbarInfo = Util.getScrollbarInfo()
          if (scrollbarInfo.width === 0) {
            document.body.classList.add('mob-navbar-body')
            hideBodyScrollbar = true
          }
        }
      })
      .on('hidden.bs.collapse', function () {
        if ($(this).hasClass('auto-collapsing')) {
          $(this).removeClass('auto-collapsing')
          return
        }

        $('.navbar').removeClass('navbar-expanded')

        if (hideBodyScrollbar) {
          document.body.classList.remove('mob-navbar-body')
        }
      })
      .on('show.bs.collapse', function () {
        $('.navbar').addClass('navbar-expanded')
        // hide other ones
        $('.navbar-collapse.show').addClass('auto-collapsing').css('transition-duration', '.1ms').collapse('hide').css('transition-duration', '')
      })

    // if navbar dropdowns are not entirely inside window area, move them accordingly
    var _adjustDropdown = function () {
      var isRTL = document.documentElement.classList.contains('rtl')
      var prop = !isRTL ? 'marginLeft' : 'marginRight'
      this.style[prop] = ''

      var rect = this.getBoundingClientRect()
      if (rect.left < 0) this.style[prop] = parseInt(-1 * rect.left) + 5 + 'px'
      else {
        var sw = document.body.scrollWidth
        if (rect.right > sw) {
          this.style[prop] = parseInt(sw - rect.right - 5) + 'px'
        }
      }
    }
    $('.navbar').on('transitionstart.adjust', '.dropdown-mega .dropdown-menu', function (ev) {
      if (ev.target !== this || ev.originalEvent.propertyName !== 'transform') return
      _adjustDropdown.call(this)
    })
    $('.navbar').on('shown.bs.dropdown', '.dropdown-mega .dropdown-menu', function () {
      var pos = window.getComputedStyle(this).position
      if (pos === 'absolute') _adjustDropdown.call(this)
    })
  }

  static _handleTabScroll () {
    var _firefox = 'MozAppearance' in document.documentElement.style
    // scroll tab button elements into view when clicked
    var _scrollIntoView = function (smooth = true) {
      var li = this.parentNode
      var nav = li.parentNode
      // if (!nav.classList.contains('nav-tabs-scroll')) return

      var navClientWidth = nav.clientWidth
      if (nav.scrollWidth <= navClientWidth) return // don't scroll if not needed

      // scroll to this element (center it)
      var _scrollLeft = li.offsetLeft - (navClientWidth - li.clientWidth) / 2
      if (_scrollLeft < 0) _scrollLeft = 0

      smooth = !Util.isReducedMotion() && smooth === true
      try {
        nav.scrollTo({
          top: 0,
          left: _scrollLeft,
          behavior: smooth ? 'smooth' : 'auto'
        })

        // firefox needs double push when scrolling back
        if (_firefox && _scrollLeft < nav.scrollLeft) {
          setTimeout(function () {
            nav.scrollTo({
              top: 0,
              left: _scrollLeft,
              behavior: smooth ? 'smooth' : 'auto'
            })
          }, 0)
        }
      } catch (e) {
        nav.scrollLeft = _scrollLeft
      }
    }

    $('.nav-tabs-scroll').each(function () {
      var active = this.querySelector('.active')
      // scroll to active element on page load
      if (active) {
        if (!_firefox) {
          _scrollIntoView.call(active, 0)
        } else { // still firefox doesn't scroll back to zero on page load!
          setTimeout(() => {
            this.scrollLeft = 1
            _scrollIntoView.call(active, 0)
          }, 500)
        }
      }

      $(this).find('a').on('click', function () {
        _scrollIntoView.call(this)
      })
    })

    // tab pane swiping
    if ('ontouchstart' in window) {
      $('.tab-sliding:not([data-swipe="none"]').each(function () {
        var allowedDir = $(this).attr('data-swipe') || null
        $(this).find('.tab-pane').on('touchstart', function (ev) {
          if (!this.classList.contains('active')) return
          var curPane = this
          var isRTL = document.documentElement.classList.contains('rtl')
          var initialTransform = !isRTL ? 'translateX(100%)' : 'translateX(-100%)'

          var touches = ev.originalEvent.changedTouches[0]

          var swipeDir = 0
          var x1 = touches.pageX
          var y1 = touches.pageY
          var t1 = Date.now()

          var curDir = 0

          var paneWidth = curPane.clientWidth
          var siblingPane = null

          function _dismiss () {
            $(curPane).off('touchmove touchend touchcancel')
            curPane.style.transform = ''
            curPane.classList.remove('tab-swiping')

            if (siblingPane) {
              siblingPane.style.transform = ''
              siblingPane.classList.remove('tab-swiping')
            }
          }

          function _reset (sibling) {
            sibling.style.transform = ''
            sibling.style.transitionDuration = '1ms'
            sibling.classList.remove('tab-swiping')
            function _transitionEnd () {
              this.style.transitionDuration = ''
              this.removeEventListener('transitionend', _transitionEnd)
            }
            sibling.addEventListener('transitionend', _transitionEnd)
          }

          $(this).on('touchmove', function (ev) {
            var touches = ev.changedTouches[0]
            var newX = touches.pageX
            var newY = touches.pageY

            if (swipeDir === 0) {
              var diffY = Math.abs(y1 - newY)
              var diffX = Math.abs(x1 - newX)

              if (diffY > diffX) {
                swipeDir = 2// vertical i.e. scroll
                $(curPane).off('touchmove')
              } else if (diffX > 10) {
                swipeDir = 1// horizontal swipe
              }
            }
            if (swipeDir !== 1) return // return if not horizontal swipe

            var moveX = parseInt(x1 - newX)
            var newDir = 0

            if ((allowedDir === null || (allowedDir === 'left')) && ((!isRTL && moveX > 0) || (isRTL && moveX < 0))) newDir = 1
            else if ((allowedDir === null || (allowedDir === 'right')) && ((!isRTL && moveX < 0) || (isRTL && moveX > 0))) newDir = -1

            if (newDir !== 0 && newDir !== curDir) {
              if (siblingPane !== null) _reset(siblingPane)// undo previous direction for when we change swipe direction before a touchend
              curDir = newDir

              var targetPane = curPane.getAttribute('data-swipe-' + (curDir === 1 ? 'next' : 'prev'))
              if (targetPane) targetPane = document.querySelector(targetPane)
              siblingPane = targetPane || (curDir === 1 ? curPane.nextElementSibling : curPane.previousElementSibling)

              if (siblingPane === null || siblingPane === curPane) {
                curDir = 0
              } else {
                curPane.classList.add('tab-swiping')
                siblingPane.classList.add('tab-swiping')
              }
            }

            var moveXabs = Math.abs(moveX)
            if (curDir !== 0 && moveXabs < paneWidth + 24) { // don't move more than 32px beyond its size
              curPane.style.transform = initialTransform + ' translateX(' + (-1 * moveX) + 'px)'
              siblingPane.style.transform = 'translateX(' + (-1 * moveX) + 'px)'
            } else if (curDir === 0 && moveXabs < 24) {
              curPane.style.transform = initialTransform + ' translateX(' + (-1 * moveX) + 'px)'
            }
          })// touchmove
            .on('touchend touchcancel', function (ev) {
              var touches = ev.originalEvent.changedTouches[0]
              var x2 = touches.pageX
              var t2 = Date.now()
              var diff = Math.abs(x2 - x1)

              _dismiss()

              if (curDir !== 0 && swipeDir === 1 &&
                                ((diff > paneWidth / 4 || diff > 100) || (diff > paneWidth / 6 && t2 - t1 < 300))
              ) { // if moved more than 1/4 of its width or 100px or 1/6 in less than 300ms
                siblingPane.classList.add('active', 'show')
                curPane.classList.remove('active', 'show')

                var id1 = curPane.id; var id2 = siblingPane.id
                $('[href="#' + id1 + '"],[data-target="#' + id1 + '"]').removeClass('active')

                var newActive = $('[href="#' + id2 + '"],[data-target="#' + id2 + '"]')
                newActive.addClass('active')

                _scrollIntoView.call(newActive.get(0))
              }
            })// touchend
        })// tab-pane touchstart
      })// each
    }// 'ontouchstart' in window
  }

  static _handleScrollTop () {
    // scroll to top button
    var _scrollBtn = document.querySelector('.btn-scroll-up')
    // return if button is not visible
    if (_scrollBtn === null || _scrollBtn.offsetParent === null) return

    var showScrollbtn = function () {
      _scrollBtn.classList.add('scroll-btn-visible')
    }

    var hideScrollBtn = function () {
      _scrollBtn.classList.remove('scroll-btn-visible')
    }

    var scrollToTop = function () {
      try {
        // ScrollToOptions parameter may not be supported on some older browsers
        var smoothScroll = !Util.isReducedMotion()
        window.scroll({
          top: 0,
          behavior: smoothScroll ? 'smooth' : 'auto'
        })
      } catch (e) {
        window.scroll(0, 0)
      }
    }

    var _modernBrowser = 'IntersectionObserver' in window
    _scrollBtn.addEventListener('click', function (e) {
      e.preventDefault()

      if (_modernBrowser) hideScrollBtn()
      scrollToTop()
    })

    if (_modernBrowser) {
      var _scrollBtnObserve = document.createElement('DIV')
      _scrollBtnObserve.classList.add('scroll-btn-observe')
      document.body.appendChild(_scrollBtnObserve)

      const observer = new window.IntersectionObserver(([entry]) => {
        var isOut = entry.intersectionRatio < 1 && entry.boundingClientRect.y < 0
        if (isOut) {
          showScrollbtn()
        } else {
          hideScrollBtn()
        }
      },
      {
        threshold: [1.0],
        delay: 100
      }
      )

      observer.observe(_scrollBtnObserve)

      /**
      setTimeout(function () {
        // initial check!
        if (observedEl.getBoundingClientRect().y < 0) {
          showScrollbtn()
        }
      }, 200)
      */
    } else {
      // if browser doesn't support `IntersectionObserver` show the scroll to top button
      // we used to listen to 'scroll' event, but not anymore
      showScrollbtn()
    }
  }

  /// /
  // we use it when a sticky element becomes stuck on top and 1 pixel of it goes out of view (because of top: -1px)
  // so IntersectionObserver is triggered with intersectionRatio < 1 and y < 0
  // then we trigger an event for it, so we may for example change its classlist to update styling
  static _handleSticky () {
    if (!window.IntersectionObserver) return
    const stickyElements = document.querySelectorAll('[class*="sticky-nav"]')
    if (stickyElements.length > 0) {
      const observer = new window.IntersectionObserver(([entry]) => {
        var isSticky = entry.intersectionRatio < 1 && entry.boundingClientRect.y < 0

        // isSticky=true means we are at sticky position
        // so if our sticky element is for example 'sticky-nav-md' and we are at sticky position
        // but our window size is above 'md' and therefore CSS rule 'position: sticky' is not applied at all
        // so we check if we are really sticky or not
        var stickyNav = entry.target.parentElement// entry.target is the `.sticky-trigger` and parentElement is the `.sticky-nav` element

        if (isSticky && !stickyNav.classList.contains('sticky-nav')) { // don't check `.sticky-nav` element because it's sticky regardless of window size
          var pos = window.getComputedStyle(stickyNav).position
          if (!(pos === 'sticky' || pos === '-webkit-sticky')) isSticky = false
        }

        const evt = new window.CustomEvent('sticky-change', { detail: { isSticky } })
        stickyNav.dispatchEvent(evt)
      },
      {
        threshold: [1.0],
        delay: 100
      }
      )

      stickyElements.forEach((stickyEl) => {
        // var pos = window.getComputedStyle(stickyEl).position
        // if (!(pos === 'sticky' || pos === '-webkit-sticky')) return

        // add a dummy child to watch
        // when it goes out of window it means sticky-nav is sticky now
        // because dummy element is top: -1px or when below navbar it's top : -1 * ($navbar-height + 1px);
        var observedChild = document.createElement(stickyEl.tagName === 'UL' ? 'LI' : 'DIV')
        observedChild.classList.add('sticky-trigger')
        stickyEl.insertBefore(observedChild, stickyEl.firstChild)

        observer.observe(observedChild)

        setTimeout(function () {
          if (observedChild.getBoundingClientRect().y < 0) {
            var isSticky = true
            if (isSticky && !stickyEl.classList.contains('sticky-nav')) {
              var pos = window.getComputedStyle(stickyEl).position
              if (!(pos === 'sticky' || pos === '-webkit-sticky')) isSticky = false
            }
            const evt = new window.CustomEvent('sticky-change', { detail: { isSticky: isSticky, initialCheck: true } })
            stickyEl.dispatchEvent(evt)
          }
        }, 200)
      })
    }
  }

  // /////////

  static _handleOther () {
    $('.input-floating-label input').each(function () {
      if (this.value !== '') this.classList.add('has-content')
      else this.classList.remove('has-content')
    })
    $(document).on('focusout', '.input-floating-label input', function (e) {
      if (this.value !== '') this.classList.add('has-content')
      else this.classList.remove('has-content')
    })
  }
}

/**
 * ------------------------------------------------------------------------
 * jQuery
 * ------------------------------------------------------------------------
*/

if (typeof $ !== 'undefined') {
  Basic._HandleBasics()
}

export default Basic
