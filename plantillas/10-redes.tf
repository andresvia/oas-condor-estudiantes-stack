resource "aws_cloudformation_stack" "redes" {
  name = "condor-estudiantes-stack-${var.branch}-redes"
  template_body = <<STACK
  {
    "Resources": {
      "SeguridadInterna": {
        "Type": "AWS::EC2::SecurityGroup",
        "Properties": {
          "GroupDescription": "Security Group Interno"
        }
      },
      "SeguridadBalanceador": {
        "Type": "AWS::EC2::SecurityGroup",
        "Properties": {
          "GroupDescription": "Security Group Externo"
        }
      },
      "IngresoInternoHTTP": {
        "Type": "AWS::EC2::SecurityGroupIngress",
        "Properties": {
          "GroupId": {
            "Fn::GetAtt": [
              "SeguridadInterna",
              "GroupId"
            ]
          },
          "SourceSecurityGroupId": {
            "Fn::GetAtt": [
              "SeguridadBalanceador",
              "GroupId"
            ]
          },
          "FromPort": 80,
          "ToPort": 80,
          "IpProtocol": "TCP"
        }
      },
      "IngresoExternoHTTP": {
        "Type": "AWS::EC2::SecurityGroupIngress",
        "Properties": {
          "GroupId": {
            "Fn::GetAtt": [
              "SeguridadBalanceador",
              "GroupId"
            ]
          },
          "CidrIp": "0.0.0.0/0",
          "FromPort": 80,
          "ToPort": 80,
          "IpProtocol": "TCP"
        }
      },
      "IngresoExternoHTTPS": {
        "Type": "AWS::EC2::SecurityGroupIngress",
        "Properties": {
          "GroupId": {
            "Fn::GetAtt": [
              "SeguridadBalanceador",
              "GroupId"
            ]
          },
          "CidrIp": "0.0.0.0/0",
          "FromPort": 443,
          "ToPort": 443,
          "IpProtocol": "TCP"
        }
      }
    },
    "Outputs": {
      "SeguridadInternaGroupId": {
        "Value": {"Fn::GetAtt": ["SeguridadInterna", "GroupId"]}
      },
      "SeguridadBalanceadorGroupId": {
        "Value": {"Fn::GetAtt": ["SeguridadBalanceador", "GroupId"]}
      }
    }
  }
STACK
}
