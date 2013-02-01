app = angular.module('HuetifulClient')

app.directive 'colorpicker', ->
  link: (scope, element, attrs, controller) ->
    element.colorpicker().on 'changeColor', (e) ->
      console.log '(idx=' + attrs.index + ') Changing color to:' + e.color.toHex()
      fn = scope.$parent.$eval(attrs.colorpicker)
      fn(attrs.index, e.color.toHex())