using KNITRO, JuMP, Base.Test

for m in [Model(solver=KnitroSolver()),
          Model(solver=KnitroSolver(KTR_PARAM_ALG=5)),
          Model(solver=KnitroSolver(hessopt=1)),
          Model(solver=KnitroSolver(options_file=joinpath(dirname(@__FILE__),
                                                          "tuner-fixed.opt"))),
          Model(solver=KnitroSolver(tuner_file=joinpath(dirname(@__FILE__),
                                                        "tuner-explore.opt")))]
    @variable(m, x[1:3]>=0)
    @NLobjective(m, Min, 9.0 - 8.0*x[1] - 6.0*x[2] - 4.0*x[3]
                            + 2.0*x[1]^2 + 2.0*x[2]^2 + x[3]^2
                            + 2.0*x[1]*x[2] + 2.0*x[1]*x[3])
    @constraint(m, x[1] + x[2] + 2.0*x[3] <= 3)
    solve(m)
    @test getvalue(x[1]) ≈ 1.3333333 atol=1.0e-5
    @test getvalue(x[2]) ≈ 0.7777777 atol=1.0e-5
    @test getvalue(x[3]) ≈ 0.4444444 atol=1.0e-5
    @test getobjectivevalue(m) ≈ 0.1111111 atol=1.0e-5
end
