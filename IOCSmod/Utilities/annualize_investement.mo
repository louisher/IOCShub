within IOCSmod.Utilities;
function annualize_investement
  "Function to calculate the annualizing factor (incl. replacements and residual value) for an investment cost"
  input Integer lifetime "Lifetime of device in years";
  input Integer observation_time "Observation time for investment cost calculation";
  input Real r "Interest rate";
  output Real ann_factor "Factor to multiply with investment cost to get annualized investement incl replacements and resdiual value";

protected
  Real q "1+r";
  Real CRF "Captial recovery factor to translate NPV at year 0 of total investment to annuities over a number of years";
  Integer n_repl "Number of replacements";
  Real inv_repl "The NPV factor of all replacement investments";
  Real res_value "Residual value NPV factor at the observation time";
  Real NPV_factor "Factor to multiply with investment cost to calculate NPV of all investments and residual value";

algorithm
  q := 1+r;
  CRF := ((q^observation_time)*r) / ((q^observation_time)-1);

  n_repl := integer(floor(observation_time/lifetime));

  // Replacement investments
  inv_repl :=0;
  for i in 1:n_repl loop
    inv_repl := inv_repl + q ^ (-i * lifetime);
  end for;

  // Residual value
  res_value :=(((n_repl + 1)*lifetime - observation_time)/lifetime)*(q^(-
    observation_time));

  // NPV factor of total investement
  NPV_factor := 1 + inv_repl - res_value;

  // Annualized investment
  ann_factor :=  NPV_factor * CRF;
end annualize_investement;
