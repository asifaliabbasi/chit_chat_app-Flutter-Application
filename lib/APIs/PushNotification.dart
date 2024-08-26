import 'package:googleapis_auth/auth_io.dart';

class GetServiceKey{
  Future<String> getServerKeyToken ()async{
     final scopes = [
       'https://www.googleapis.com/auth/userinfo.emial',
       'https://www.googleapis.com/auth/firebase.database',
       'https://www.googleapis.com/auth/firebase.messaging',
     ];

     final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(

         {

             "type": "service_account",
             "project_id": "chat-a-1263b",
             "private_key_id": "71217aac74c09a1080a75071e183c9909994e903",
             "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDhxsvdstdWfbcU\nxYgTNh4WotPwtDo71h8pzSKSVsW1PEIZRfF6KfgNFCC97pdH7fbW72ZIpVFgMgES\nSnCRnGUeZfWYQMXkcwvPbHToRM7uZMYBPN1bFpC/0mvzuMIYMiYt794yQL7SoyUx\nVjm0xlBd+9b/pFZxUMdUD725y6vjJskd6ciSIyxpFrXChp44Np+Lpuy5Gh6kiYzx\nf+uxc0Cib7DeY34wbyQsSBXBLGZs1/34f9PJ63aLhzJVLMtriNMiE8lD12s1iOCD\nogi1qmdfR7t4GOuR/J6P3hwBOksmbPgRCfhyilU9Gy3WSX15Ac0aHofn3RJdg+6A\nrX/uR6pbAgMBAAECggEANk+Q+OqtfEPPh7KgsiZhhIZ0v0FLhNtUMcUD3Pn8o0U0\njUnS9dUks1i1K5s6TvZCW5/JFg6WjbJZqaG4hH5/oJlcQ9zI/dRi8emgEcODl7ss\nGl4ezWuXNF2U1FMMda+SmZhK9gG3JYpTRxP7262c5Y7QQDyzAp0w5drHg+snlQNq\nn3YYlKBWdC3k1BCh3LuH4GpU8kvmB/2cDsC8V0UhXvsZewNCkmJtIws7jo8NY1AH\nF6GMEJlqlFE6npC1GGdntWGmPQh/vPTgqablCreDOgyQoRnKJIAKvaTnXWzJUHHj\nkWUGOk9H/oUAIv4oFpsPFh7GsPYZ9pxKxPbtOBQzGQKBgQD+yrptU4iL6lQkrtob\nGHlvz/gyomEvAguHkhKr5Kb+pGIWs6buPsvmLQCHrvGpAojKCAx3uPxv6L2KkmaF\nuu+/aRhfgkLVEpgRGXiiXHxTiur4iw1IVVjOTwkMzIHFkHW8ai+QMtVkcCZvvJ+T\nqoHVJsroyi2VVfQfvwQxAecTpQKBgQDi2NlCWv2Aew1P+jRVDKcC0XzJopInOI7g\nMmq/OTLPTEyAr9kI/dEK4xE2D9lG+2CexyVOW8TmfOwyFXB9Xq7NZagRKf+Nnr/P\nAAi3d0sc4apBvOQ5DHDm4OrNd5anDLLJmqonC7w+NnlRvabPeL3wjx7+4PDNBmvA\ngtsTif9l/wKBgGtpM2ZbTLkPNCGyxKefjbIhTlSqN6YFiq7AWba1UeEPk3pWigzt\n1C9Y0Vxh1+aT9u6UrgzaozDaQO1mAmpmACQFPg0lcN86U3kB7+UicBcX/S6CEDtq\nH2H516rZm+uZlsizSxHTHDqXPNzl+6/YtZsSG4A/my/VaHDpqe6vCqcxAoGAHWaZ\nkf4VCQfpy8nT6on/Q2A/WirV4nt0GR6vsyUIrtFmwO8JpB6xb0XKv0UCli6ScUHC\nVguS04SxYDRjJfyVj01zoPXeh05h8cRBXPX7KD0fQfHnanVwVJwmEodDYVdF/Ncs\n4m6k8TNCOhPogM9XXsxN6h7hVtFUOdk756ZlEaUCgYEA6ONNy4nPQLmDq6+GqRmJ\nYdoqb9zGisDRnvoQJzZ3xYzaLxJhYlFaPrxZmRLD2iVJJq0R0mRgke+mTgpgmUqp\n2PH3b0dNn3EfJthvuPGV8pbWq8n+ZT/j+rlfjcH16/OxCB+6s6nn4Hv2f3sBtpNG\nwnJ68MpvUpI1EHsytfkqaNY=\n-----END PRIVATE KEY-----\n",
             "client_email": "firebase-adminsdk-4kjog@chat-a-1263b.iam.gserviceaccount.com",
             "client_id": "112501070839222837813",
             "auth_uri": "https://accounts.google.com/o/oauth2/auth",
             "token_uri": "https://oauth2.googleapis.com/token",
             "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
             "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-4kjog%40chat-a-1263b.iam.gserviceaccount.com",
             "universe_domain": "googleapis.com"


         }
         ), scopes);
    final accessServerKey = client.credentials.accessToken.data;
     return accessServerKey ;
  }
}