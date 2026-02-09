within IOCSmod.ComponentModels.BaseClasses;
function AnnInvCost
  input Real inv_cost "Relative investment cost per unit of Size";
  input Real interest_rate "Interest rate";
  input Integer lifetime "Lifetime in years";
  input Integer observation_time "Observation time in years";
  output Real annualized_investment_cost "Annualized investment cost per unit";
protected
  Real q;
  Real CRF;
  Integer n_repl;
  Real res_value;
  Real inv_repl;
  constant Integer MAX_REPL = 4;
algorithm
  q := 1 + interest_rate;
  CRF := (q^observation_time * interest_rate) / ((q^observation_time) - 1);
  n_repl := integer(floor(observation_time / lifetime));
  res_value := (((n_repl + 1) * lifetime - observation_time) / lifetime) * q^(-observation_time);

  inv_repl := 0;
  for i in 1:MAX_REPL loop
    if i <= n_repl then
      inv_repl := inv_repl + q^(-i * lifetime);
    end if;
  end for;

  annualized_investment_cost := inv_cost * (1 + inv_repl - res_value) * CRF;

end AnnInvCost;
