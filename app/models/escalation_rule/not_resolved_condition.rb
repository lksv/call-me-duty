class EscalationRule::NotResolvedCondition < EscalationRule::BaseCondition
  # `#execute` method is true by default
  #
  # note that #execute could be resolved to false when incident is snoozed
  # or solved.
end
