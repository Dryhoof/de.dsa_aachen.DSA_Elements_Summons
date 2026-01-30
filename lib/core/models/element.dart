enum DsaElement {
  fire(counterIndex: 1),
  water(counterIndex: 0),
  life(counterIndex: 3),
  ice(counterIndex: 2),
  stone(counterIndex: 5),
  air(counterIndex: 4);

  final int counterIndex;
  const DsaElement({required this.counterIndex});

  DsaElement get counterElement => DsaElement.values[counterIndex];
}
