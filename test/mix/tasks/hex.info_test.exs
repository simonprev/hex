defmodule Mix.Tasks.Hex.InfoTest do
  use HexTest.Case
  @moduletag :integration

  test "package" do
    Mix.Tasks.Hex.Info.run(["ex_doc"])
    assert_received {:mix_shell, :info, ["Some description\n"]}
    assert_received {:mix_shell, :info, ["Config: {:ex_doc, \"~> 0.1.0\"}"]}
    assert_received {:mix_shell, :info, ["Maintainers: John Doe, Jane Doe"]}
    assert_received {:mix_shell, :info, ["Releases: 0.1.0, 0.1.0-rc1, 0.0.1\n"]}

    Mix.Tasks.Hex.Info.run(["no_package"])
    assert_received {:mix_shell, :error, ["No package with name no_package"]}
  end

  test "package with retired release" do
    Mix.Tasks.Hex.Info.run(["tired"])
    assert_received {:mix_shell, :info, ["Releases: 0.2.0, 0.1.0 (retired)\n"]}
  end

  test "package with custom repo" do
    bypass_repo("myorg")
    Mix.Tasks.Hex.Info.run(["ecto", "--organization", "myorg"])
    assert_received {:mix_shell, :info, ["ecto description\n"]}
  end

  test "release" do
    Mix.Tasks.Hex.Info.run(["ex_doc", "0.0.1"])
    assert_received {:mix_shell, :info, ["Config: {:ex_doc, \"~> 0.0.1\"}"]}

    Mix.Tasks.Hex.Info.run(["ex_doc", "0.1.0-rc1"])
    assert_received {:mix_shell, :info, ["Config: {:ex_doc, \"~> 0.1.0-rc1\"}"]}

    Mix.Tasks.Hex.Info.run(["ex_doc", "1.2.3"])
    assert_received {:mix_shell, :error, ["No release with name ex_doc 1.2.3"]}
  end
end
