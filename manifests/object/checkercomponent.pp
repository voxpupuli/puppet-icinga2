define icinga2::object::checkercomponent(
  $target,
  $order  = '10',
) {

  validate_absolute_path($target)
  validate_integer($order)

  # create object
  icinga2::object { "checkercomponent::${title}":
    object_name => $title,
    object_type => 'CheckerComponent',
    attrs       => {},
    target      => $target,
    order       => $order,
  }
}
