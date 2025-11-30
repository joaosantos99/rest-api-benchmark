<?php

/**
 * Prints MD5 hash of data
 */
function printHash($data, $label = ''): string
{
    $str = json_encode($data);
    $hash = md5($str);
    return ($label ? $label . ' ' : '') . 'MD5 Hash: ' . $hash;
}

/**
 * Performs JSON serialization/deserialization benchmark
 */
function json_serde(): string
{
    $sampleData = [
        'users' => [
            ['id' => 1, 'name' => 'Alice', 'email' => 'alice@example.com', 'active' => true],
            ['id' => 2, 'name' => 'Bob', 'email' => 'bob@example.com', 'active' => false],
            ['id' => 3, 'name' => 'Charlie', 'email' => 'charlie@example.com', 'active' => true]
        ],
        'metadata' => [
            'version' => '1.0.0',
            'timestamp' => date('c'),
            'settings' => [
                'theme' => 'dark',
                'notifications' => true,
                'language' => 'en'
            ]
        ],
        'statistics' => [
            'totalUsers' => 3,
            'activeUsers' => 2,
            'averageAge' => 28.5,
            'tags' => ['javascript', 'nodejs', 'benchmark', 'json', 'serialization']
        ]
    ];

    $n = 100; // Number of serialization/deserialization cycles

    $jsonStr = json_encode($sampleData);
    $parsed = json_decode($jsonStr, true);
    $originalHash = printHash($parsed, 'Original');

    $results = [];
    for ($i = 0; $i < $n; $i++) {
        $serialized = json_encode($parsed);
        $deserialized = json_decode($serialized, true);
        $results[] = $deserialized;
    }

    $finalHash = printHash($results, "x{$n} Cycles");

    return implode("\n", [
        $originalHash,
        $finalHash,
        "Performed {$n} serialization/deserialization cycles",
        'Original data size: ' . strlen($jsonStr) . ' bytes',
        'Final array size: ' . count($results) . ' objects'
    ]);
}

?>

