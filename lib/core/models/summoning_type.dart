enum SummoningType {
  servant(summonCost: 4, controlCost: 2),
  djinn(summonCost: 8, controlCost: 4),
  master(summonCost: 12, controlCost: 8);

  final int summonCost;
  final int controlCost;
  const SummoningType({required this.summonCost, required this.controlCost});
}
