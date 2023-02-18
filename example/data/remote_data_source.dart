import 'package:network_bound_resource/src/domain/network_bound_resource.dart';

import '../domain/post_entity.dart';

class RemoteDataSource {
  RemoteDataSource(this.networkBoundResource);

  final NetworkBoundResource networkBoundResource;

  Future<List<PostEntity>> getPosts() async {
    final response = await networkBoundResource.executeGet(
      tableName: 'posts',
      path: 'posts',
    );
    return postEntityFromJson(response.data);
  }

  Future<void> savePost(PostEntity postEntity) async {
    await networkBoundResource.executePost(
      path: 'posts',
      data: postEntity.toJson(),
    );
  }

  Future<void> updatePost(int postId) async {
    await networkBoundResource.executePut(
      path: 'posts/$postId',
    );
  }

  Future<void> deletePost(int postId) async {
    await networkBoundResource.executeDelete(
      path: 'posts/$postId',
    );
  }

  Future<void> patchPost(int postId) async {
    await networkBoundResource.executePatch(
      path: 'posts/$postId',
    );
  }
}
