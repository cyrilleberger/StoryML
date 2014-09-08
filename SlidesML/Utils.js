function numberifyList(list)
{
  var new_list = []
  for(var i = 0; i < list.length; ++i)
  {
    new_list.push("#" + list[i])
  }
  return new_list;
}

function itemifyList(list)
{
  var new_list = []
  for(var i = 0; i < list.length; ++i)
  {
    new_list.push("*" + list[i])
  }
  return new_list;
}
