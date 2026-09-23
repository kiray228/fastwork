import 'package:flutter/material.dart';

/// Значок для категории работ.
///
/// Справочник категорий лежит в `fastwork_core`, а значки — здесь. Так и
/// задумано: ядро не знает про Flutter, а значок — это Flutter. Ядру
/// нужен ключ `plumber`, экрану — ещё и картинка с ключом.
///
/// Незнакомый ключ получает нейтральный портфель, а не падение: новые
/// категории могут прийти с сервера раньше, чем обновится приложение.
IconData categoryIcon(String id) => switch (id) {
      'seller' => Icons.storefront_rounded,
      'cashier' => Icons.point_of_sale_rounded,
      'sales_floor' => Icons.shopping_basket_rounded,
      'merchandiser' => Icons.shelves,
      'promoter' => Icons.campaign_rounded,
      'inventory' => Icons.inventory_rounded,
      'loader' => Icons.fitness_center_rounded,
      'warehouse' => Icons.warehouse_rounded,
      'picker' => Icons.shopping_cart_checkout_rounded,
      'packer' => Icons.inventory_2_rounded,
      'forklift' => Icons.forklift,
      'courier' => Icons.delivery_dining_rounded,
      'driver' => Icons.local_shipping_rounded,
      'cook' => Icons.soup_kitchen_rounded,
      'cook_helper' => Icons.restaurant_rounded,
      'waiter' => Icons.room_service_rounded,
      'barista' => Icons.coffee_rounded,
      'bartender' => Icons.local_bar_rounded,
      'dishwasher' => Icons.wash_rounded,
      'baker' => Icons.bakery_dining_rounded,
      'cleaner' => Icons.cleaning_services_rounded,
      'housekeeper' => Icons.bed_rounded,
      'janitor' => Icons.yard_rounded,
      'car_wash' => Icons.local_car_wash_rounded,
      'plumber' => Icons.plumbing_rounded,
      'electrician' => Icons.electrical_services_rounded,
      'handyman' => Icons.handyman_rounded,
      'builder' => Icons.construction_rounded,
      'painter' => Icons.format_paint_rounded,
      'welder' => Icons.local_fire_department_rounded,
      'furniture' => Icons.chair_rounded,
      'production' => Icons.precision_manufacturing_rounded,
      'event_staff' => Icons.celebration_rounded,
      'hostess' => Icons.emoji_people_rounded,
      'security' => Icons.shield_rounded,
      'animator' => Icons.theater_comedy_rounded,
      'call_center' => Icons.headset_mic_rounded,
      'reception' => Icons.support_agent_rounded,
      'nanny' => Icons.child_care_rounded,
      _ => Icons.work_rounded,
    };
