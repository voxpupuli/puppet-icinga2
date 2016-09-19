define icinga2::object::notificationcomponent(
  $target,
  $order  = '10',
) {

  validate_absolute_path($target)
  validate_integer($order)

  # create object
  icinga2::object { "notificationcomponent::${title}":
    object_name => $title,
    object_type => 'NotificationComponent',
    attrs       => {},
    target      => $target,
    order      => $order,
  }
}
