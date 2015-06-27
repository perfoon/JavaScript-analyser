var a = [5, 1, 3, 2, 4];
bubbleSort(a);

function bubbleSort(list) {
  var swapped;
  do {
    swapped = false;
    for (var i=0; i<list.length-1; i++) {
      if (list[i] > list[i+1]) {
        var temp = list[i];
        list[i] = list[i+1];
        list[i+1] = temp;
        swapped = true;
      }
    }
  } while (swapped);
}
